import AVFoundation
import DesignSystem
import UIKit
import Vision

/// View Controller for the `Scanner` storyboard XIB
/// It is initialised with a `viewModel` of type: `QRScanningViewModel`
/// and a `scanningController` of type: `ScanningController`
///
/// This screen includes the following views:
///   - `cameraView` (type: `UIView`)
///   - `instructionsLabel` (type: `UILabel`)
///   - `imageView`  (type: `UIImageView`)
///  This screen is used to scan a QR code, you can provide a format within the `viewModel`.
///
///  The `instructionsLabel` and `cameraView` are within `view`. The view controller adds the `childView`

public final class ScanningViewController<CaptureSession: SharedScreens.CaptureSession>:
    UIViewController,
    VoiceOverFocus,
    AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let previewLayer: AVCaptureVideoPreviewLayer
    var videoDataOutput: AVCaptureVideoDataOutput?

    let captureDevice: any CaptureDevice.Type
    let captureSession: CaptureSession
    private nonisolated let requestType: VNImageBasedRequest.Type
    nonisolated let errorHandler: @Sendable (Error?) -> Void
    var imageView: UIImageView = .init(image: .init(named: "qrscan", in: .module, compatibleWith: nil))
    
    public var initialVoiceOverView: UIView {
        instructionsLabel
    }
    
    let cameraView = UIView()
    
    lazy var instructionsLabel: UILabel = {
        let result = UILabel()
        result .translatesAutoresizingMaskIntoConstraints = false
        result.accessibilityIdentifier = "instructionsLabel"
        result.text = viewModel.instructionText
        result.numberOfLines = 0
        result.textAlignment = .center
        result.font = DesignSystem.Font.Base.bodyBold
        result.textColor = .white
        return result
    }()
    
    private nonisolated let isScanningQueue = DispatchQueue(label: "isScanningQueue")
    private nonisolated(unsafe) var internalIsScanning: Bool = true
    private nonisolated var isScanning: Bool {
        get {
            isScanningQueue.sync { internalIsScanning }
        }
        set {
            isScanningQueue.sync { self.internalIsScanning = newValue }
        }
    }

    public var viewModel: QRScanningViewModel
    
    var overlayView: ScanOverlayView?
    var imageViewHeightConstraint: NSLayoutConstraint?
    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewXAnchorConstraint: NSLayoutConstraint?
    var imageViewYAnchorConstraint: NSLayoutConstraint?
    
    let processingQueue = DispatchQueue(label: "barcodeScannerQueue",
                                        qos: .userInitiated,
                                        attributes: [],
                                        autoreleaseFrequency: .workItem)
    
    private var didSetupCapture = false
    private var didCleanup = false

    var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .unknown
    }

    /// Initialiser for the `Scanning` view controller.
    /// Requires a single parameter.
    /// - Parameter viewModel: `QRScanningViewModel`
    public init(
        viewModel: QRScanningViewModel,
        captureDevice: any CaptureDevice.Type = AVCaptureDevice.self,
        captureSession: CaptureSession = AVCaptureSession(),
        requestType: VNImageBasedRequest.Type = VNDetectBarcodesRequest.self,
        errorHandler: @escaping @Sendable (Error?) -> Void = { _ in /* empty default implementation to avoid breaking change */}
    ) {
        self.viewModel = viewModel
        self.captureDevice = captureDevice
        self.captureSession = captureSession
        self.previewLayer = captureSession.makePreviewLayer()
        self.requestType = requestType
        self.errorHandler = errorHandler
        super.init(nibName: nil, bundle: .module)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = viewModel.title
        configureNavigationAppearance()
        view.addSubview(cameraView)
        cameraView.bindToSuperviewEdges()
        setupInstructionLabel()
        Task { @MainActor [weak self] in
            guard let self else { return }
            var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
            if self.windowOrientation != .unknown, let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation) {
                initialVideoOrientation = videoOrientation
            }
            self.previewLayer.connection?.videoOrientation = initialVideoOrientation
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        setBackButtonTitle(
            title: GDSLocalisedString(stringKey: "GDSCommonBackButton", bundle: .module),
            isHidden: false
        )

        if let rightBarButtonTitle = viewModel.rightBarButtonTitle {
            navigationItem.rightBarButtonItem = .init(
                title: rightBarButtonTitle.value,
                style: .plain,
                target: self,
                action: #selector(dismissScreen)
            )
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "right-bar-button"
        }

        if didSetupCapture {
            startScanning()
            return
        }
        didSetupCapture = true
        makeScannerCaptureView()
        updateRegionOfInterest()
        updatePreviewLayerFrame()
        addImageOverlay()
        updateImageOverlay()
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task { @MainActor in
            if let focusView = try? initialVoiceOverView {
                UIAccessibility.post(notification: .screenChanged, argument: focusView)
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
        stopAnimation()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setPreviewSize()
    }

    func cleanup() {
        guard !didCleanup else { return }
        didCleanup = true

        stopScanning()
        stopAnimation()

        // Nil delegate on the processing queue to prevent race with in-flight captureOutput calls
        processingQueue.sync {
            self.videoDataOutput?.setSampleBufferDelegate(nil, queue: nil)
        }
        videoDataOutput = nil

        // Remove preview layer from superlayer (idempotent)
        if previewLayer.superlayer != nil {
            previewLayer.removeFromSuperlayer()
        }

        // Break the preview layer's reference to the session
        previewLayer.session = nil
    }

    @objc private func dismissScreen() {
        dismiss(animated: true)
        viewModel.didDismiss()
    }

    /// Function to process the detected scanned barcode.
    /// Called as soon as a QR Code is detected
    /// Pulls out the first scanned ID
    ///
    /// Vision invokes this completion handler synchronously on the thread that
    /// calls `handler.perform(_:)` — i.e. the background `processingQueue` inside
    /// the nonisolated `captureOutput`. It must therefore be `nonisolated`; it only
    /// touches the (thread-agnostic) Vision `request` and hops to the main actor
    /// via the `Task` to run `didScan`.
    ///
    /// `internal` (not `private`) so unit tests can drive the result-parsing and
    /// `didScan` dispatch directly, without needing a live Vision `perform`.
    nonisolated func detectedBarcode(_ request: VNRequest, _ error: Error?) {
        guard let results = request.results else {
            return
        }
        let qrCodes = results
            .compactMap { $0 as? VNBarcodeObservation }
            .compactMap { $0.payloadStringValue }
        guard let qrCode = qrCodes.first else { return }
        Task { [weak self] in
            await self?.didScan(string: qrCode)
        }
    }
    
    @MainActor
    func didScan(string: String) async {
        guard isScanning else { return }
        isScanning = false
        await viewModel.didScan(value: string, in: overlayView ?? view)
        isScanning = true
    }
    
    // - MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    public nonisolated func captureOutput(_ output: AVCaptureOutput,
                                          didOutput sampleBuffer: CMSampleBuffer,
                                          from connection: AVCaptureConnection) {
        guard isScanning,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Build a fresh request per frame rather than reusing a single shared,
        // main-actor-constructed `VNImageBasedRequest`. The completion closure here is
        // created in this nonisolated context, so it carries no main-actor isolation and
        // is safe to run on the background `processingQueue` (avoids EXC_BREAKPOINT).
        let request = requestType.init { [weak self] request, error in
            self?.detectedBarcode(request, error)
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            options: [:])
        do {
            try handler.perform([request])
        } catch {
            errorHandler(error)
        }
    }

    deinit {
        // `ScanningViewController` is `@MainActor`-isolated and UIKit always
        // deallocates view controllers on the main thread, so `assumeIsolated`
        // lets the nonisolated `deinit` run main-actor `cleanup()` safely.
        MainActor.assumeIsolated {
            cleanup()
        }
    }
}
