import AVFoundation
@testable import SharedScreens

struct MockCaptureDeviceInput {}

/// Driven only from the main actor in tests, so `@unchecked Sendable` is safe here.
final class MockCaptureSession: CaptureSession, @unchecked Sendable {
    private(set) var output: AVCaptureOutput?
    private(set) var removedOutput: AVCaptureOutput?

    var layer: AVCaptureVideoPreviewLayer {
        AVCaptureVideoPreviewLayer()
    }

    var isRunning: Bool = false

    func startRunning() {
        isRunning = true
    }

    func stopRunning() {
        isRunning = false
    }

    func beginConfiguration() {}

    func commitConfiguration() {}

    func canAddInput(_ input: MockCaptureDeviceInput) -> Bool {
        true
    }

    func addInput(_ input: MockCaptureDeviceInput) {}

    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        true
    }

    func addOutput(_ output: AVCaptureOutput) {
        self.output = output
    }

    func removeOutput(_ output: AVCaptureOutput) {
        if self.output === output {
            removedOutput = output
            self.output = nil
        }
    }
}

final class MockCaptureDevice: CaptureDevice {
    var input: MockCaptureDeviceInput { get throws { MockCaptureDeviceInput() } }
    static func `for`(mediaType: AVMediaType) -> Self? { Self() }
}

/// A capture device that is never available, used to exercise the error path.
final class UnavailableCaptureDevice: CaptureDevice {
    var input: MockCaptureDeviceInput { get throws { MockCaptureDeviceInput() } }
    static func `for`(mediaType: AVMediaType) -> Self? { nil }
}
