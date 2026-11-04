import AVFoundation
@testable import DesignSystem
@testable import SharedScreens
import Testing
import UIKit
import Vision

@MainActor
struct ScanningViewControllerTests {

    // MARK: - Helpers

    private func makeSUT(
        viewModel: MockQRScanningViewModel = MockQRScanningViewModel(),
        captureDevice: any CaptureDevice.Type = MockCaptureDevice.self,
        captureSession: MockCaptureSession = MockCaptureSession(),
        requestType: VNImageBasedRequest.Type = MockDetectBarcodeRequest.self,
        errorHandler: @escaping @Sendable (Error?) -> Void = { _ in }
    ) -> ScanningViewController<MockCaptureSession> {
        ScanningViewController(
            viewModel: viewModel,
            captureDevice: captureDevice,
            captureSession: captureSession,
            requestType: requestType,
            errorHandler: errorHandler
        )
    }

    /// Drives the full `viewWillAppear` → capture-setup path.
    private func appear(_ sut: ScanningViewController<MockCaptureSession>) {
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }

    private func disappear(_ sut: ScanningViewController<MockCaptureSession>) {
        sut.beginAppearanceTransition(false, animated: false)
        sut.endAppearanceTransition()
    }

    /// Polls a condition on the main actor until true or the timeout elapses.
    /// Needed because `detectedBarcode` dispatches to `didScan` via a `Task`.
    private func waitUntil(
        timeout: Duration = .seconds(2),
        _ condition: @MainActor () -> Bool
    ) async {
        let deadline = ContinuousClock.now.advanced(by: timeout)
        while ContinuousClock.now < deadline {
            if condition() { return }
            try? await Task.sleep(for: .milliseconds(20))
        }
    }

    // MARK: - Construction / UI

    @Test
    func titleIsSetFromViewModel() {
        let sut = makeSUT(viewModel: MockQRScanningViewModel(title: "My Scanner"))
        appear(sut)
        #expect(sut.title == "My Scanner")
        #expect(sut.navigationItem.hidesBackButton == false)
    }

    @Test
    func instructionsLabelReflectsViewModel() {
        let sut = makeSUT(
            viewModel: MockQRScanningViewModel(instructionText: "Point at the code")
        )
        appear(sut)
        let label: UILabel? = sut.view[child: "instructionsLabel"]
        #expect(label != nil)
        #expect(label?.text == "Point at the code")
        #expect(label?.textColor == .white)
        #expect(label?.font == DesignSystem.Font.Base.bodyBold)
    }

    @Test
    func navigationAppearanceIsTransparentWithWhiteTitle() throws {
        let sut = makeSUT()
        appear(sut)
        let appearance = try #require(sut.navigationItem.standardAppearance)
        #expect(appearance.titleTextAttributes[.foregroundColor] as? UIColor == .white)
        #expect(appearance.largeTitleTextAttributes[.foregroundColor] as? UIColor == .white)
        #expect(sut.navigationItem.compactAppearance == appearance)
        #expect(sut.navigationItem.scrollEdgeAppearance == appearance)
    }

    // MARK: - Scanning lifecycle

    @Test
    func startAndStopScanningTogglesSession() async {
        let session = MockCaptureSession()
        let sut = makeSUT(captureSession: session)
        appear(sut)

        await waitUntil { session.isRunning }
        #expect(session.isRunning)

        sut.stopScanning()
        await waitUntil { session.isRunning == false }
        #expect(session.isRunning == false)

        sut.startScanning()
        await waitUntil { session.isRunning }
        #expect(session.isRunning)
    }

    @Test
    func sessionStopsWhenViewDisappears() async {
        let session = MockCaptureSession()
        let sut = makeSUT(captureSession: session)
        appear(sut)
        await waitUntil { session.isRunning }

        disappear(sut)

        await waitUntil { session.isRunning == false }
        #expect(session.isRunning == false)
    }

    @Test
    func metadataOutputIsConfiguredWithDelegate() throws {
        let session = MockCaptureSession()
        let sut = makeSUT(captureSession: session)
        appear(sut)

        let output = try #require(session.output as? AVCaptureVideoDataOutput)
        #expect(output.alwaysDiscardsLateVideoFrames)
        #expect(output.sampleBufferDelegate === sut)
        #expect(output.sampleBufferCallbackQueue === sut.processingQueue)
    }

    // MARK: - Cleanup

    @Test
    func cleanupNilsSampleBufferDelegate() throws {
        let session = MockCaptureSession()
        let sut = makeSUT(captureSession: session)
        appear(sut)

        let output = try #require(session.output as? AVCaptureVideoDataOutput)
        #expect(output.sampleBufferDelegate === sut)

        sut.cleanup()

        #expect(output.sampleBufferDelegate == nil)
    }

    @Test
    func cleanupRemovesPreviewLayer() {
        let sut = makeSUT()
        appear(sut)
        let layer = sut.previewLayer
        #expect(layer.superlayer != nil)

        sut.cleanup()

        #expect(layer.superlayer == nil)
    }

    // MARK: - Error handling

    @Test
    func errorHandlerIsCalledWhenCaptureDeviceUnavailable() {
        let recorder = ErrorHandlerRecorder()
        let sut = makeSUT(
            captureDevice: UnavailableCaptureDevice.self,
            errorHandler: recorder.handler
        )

        appear(sut)

        #expect(recorder.callCount > 0)
        #expect(recorder.lastError == nil)
    }

    @Test
    func errorHandlerNotCalledDuringNormalSetup() {
        let recorder = ErrorHandlerRecorder()
        let sut = makeSUT(errorHandler: recorder.handler)

        appear(sut)
        disappear(sut)

        #expect(recorder.callCount == 0)
    }

    // MARK: - Barcode detection

    @Test
    func detectedBarcodeWithNoResultsDoesNotScan() async {
        let viewModel = MockQRScanningViewModel()
        let sut = makeSUT(viewModel: viewModel)
        appear(sut)

        sut.detectedBarcode(MockBarcodeRequest(results: nil), nil)

        // Give any erroneously-scheduled Task a chance to run, then assert nothing fired.
        try? await Task.sleep(for: .milliseconds(100))
        #expect(viewModel.didCallDidScan == false)
    }

    @Test
    func detectedBarcodeWithResultDeliversScannedValue() async {
        let viewModel = MockQRScanningViewModel()
        let sut = makeSUT(viewModel: viewModel)
        appear(sut)

        sut.detectedBarcode(
            MockBarcodeRequest(results: [MockBarcodeObservation("https://example.com/ABC123")]),
            nil
        )

        await waitUntil { viewModel.didCallDidScan }
        #expect(viewModel.didCallDidScan)
        #expect(viewModel.scannedValue == "https://example.com/ABC123")
    }

    // MARK: - Memory

    @Test
    func deallocatesAfterCleanup() async {
        weak var weakSUT: ScanningViewController<MockCaptureSession>?

        autoreleasepool {
            let sut = makeSUT()
            appear(sut)
            weakSUT = sut
        }

        await waitUntil { weakSUT == nil }
        #expect(weakSUT == nil)
    }
}
