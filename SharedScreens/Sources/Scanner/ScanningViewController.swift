import AVFoundation
import DesignSystem
import UIKit
import Vision

private enum PulseAnimation {
    static let scaleDelta: CGFloat = 0.05 // Pulse ±5% from center
    static let duration: TimeInterval = 1.0
}

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
    BaseViewController,
    VoiceOverFocus,
    AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let previewLayer: AVCaptureVideoPreviewLayer
    var videoDataOutput: AVCaptureVideoDataOutput?

    let captureDevice: any CaptureDevice.Type
    let captureSession: CaptureSession
    private nonisolated let requestType: VNImageBasedRequest.Type
    nonisolated let errorHandler: @Sendable (Error?) -> Void
    private var imageView: UIImageView = .init(image: .init(named: "qrscan", in: .module, compatibleWith: nil))
    
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
    
    private var overlayView: ScanOverlayView?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var imageViewWidthConstraint: NSLayoutConstraint?
    private var imageViewXAnchorConstraint: NSLayoutConstraint?
    private var imageViewYAnchorConstraint: NSLayoutConstraint?
    
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
        super.init(viewModel: viewModel as? SharedScreensBaseViewModel, nibName: nil, bundle: .module)
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

    /// Keeps the scanner title legible over the darkened camera preview without
    /// mutating the shared navigation bar or applying a blur effect such as systemChromeMaterial.
    private func configureNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationItem.compactScrollEdgeAppearance = appearance
        }
    }
    
    func setPreviewSize() {
        let deviceOrientation = UIDevice.current.orientation
        guard let newVideoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation)
        else {
            return
        }
        
        let existingOrientaton = previewLayer.connection?.videoOrientation
        
        previewLayer.connection?.videoOrientation = newVideoOrientation
        cameraView.layer.needsDisplayOnBoundsChange = true
        
        let bounds = view.bounds
        
        var newFrame: CGRect
        
        switch (existingOrientaton?.isLandscape, newVideoOrientation.isLandscape) {
        case (true, false), (false, true):
            newFrame = CGRect(
                x: 0,
                y: 0,
                width: bounds.maxY - bounds.minY,
                height: bounds.maxX - bounds.minX
            )
        default:
            newFrame = CGRect(
                x: 0,
                y: 0,
                width: bounds.maxX - bounds.minX,
                height: bounds.maxY - bounds.minY
            )
        }
        updateImageOverlay()
        
        previewLayer.frame = newFrame
    }
    
    private func updateRegionOfInterest() {
        previewLayer.layoutIfNeeded()
        cameraView.layoutIfNeeded()
    }
    
    func startAnimation() {
        imageView.transform = CGAffineTransform(
            scaleX: 1.0 - PulseAnimation.scaleDelta,
            y: 1.0 - PulseAnimation.scaleDelta
        )

        UIView.animate(
            withDuration: PulseAnimation.duration,
            delay: 0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                self.imageView.transform = CGAffineTransform(
                    scaleX: 1.0 + PulseAnimation.scaleDelta,
                    y: 1.0 + PulseAnimation.scaleDelta
                )
            }
        )
    }

    private func stopAnimation() {
        imageView.layer.removeAllAnimations()
        imageView.transform = .identity
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

extension ScanningViewController {
    func makeScannerCaptureView() {
        captureSession.beginConfiguration()
        setupVideoDisplay()
        setupMetadataCapture()
        captureSession.commitConfiguration()
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.clipsToBounds = true
        cameraView.layer.addSublayer(previewLayer)
        startScanning()
        
        overlayView = .init()
        guard let overlayView else { return }
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor)
        ])
    }

    func addImageOverlay() {
        guard let overlayView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(imageView)
        updateImageOverlay()
    }

    func updateImageOverlay() {
        guard let overlayView else { return }
        
        imageViewHeightConstraint?.isActive = false
        imageViewWidthConstraint?.isActive = false
        imageViewXAnchorConstraint?.isActive = false
        imageViewYAnchorConstraint?.isActive = false
        
        imageViewXAnchorConstraint = imageView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor)
        imageViewYAnchorConstraint = imageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        
        let sizeAdjustment = UIDevice.current.orientation.isLandscape ? 0.51 : 0.6
        let landscapeOffset = UIDevice.current.orientation.isLandscape ? 30.0 : 0
        let min = min(view.bounds.height, view.bounds.width)
        let size = min * sizeAdjustment
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: size)
        imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: size)
        imageViewYAnchorConstraint = imageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: landscapeOffset)
        
        imageViewXAnchorConstraint?.isActive = true
        imageViewYAnchorConstraint?.isActive = true
        imageViewHeightConstraint?.isActive = true
        imageViewWidthConstraint?.isActive = true
        cameraView.layoutIfNeeded()
    }
}
