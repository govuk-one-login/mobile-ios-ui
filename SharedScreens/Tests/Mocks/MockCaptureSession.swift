import AVFoundation
@testable import SharedScreens

struct MockCaptureDeviceInput {}

/// Driven only from the main actor in tests, so `@unchecked Sendable` is safe here.
final class MockCaptureSession: CaptureSession, @unchecked Sendable {
    private(set) var output: AVCaptureOutput?
    var isRunning: Bool = false

    func makePreviewLayer() -> AVCaptureVideoPreviewLayer {
        AVCaptureVideoPreviewLayer()
    }

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

/// Error thrown by `ThrowingCaptureDevice.input`, standing in for the
/// `AVError` that `AVCaptureDeviceInput(device:)` throws on permission denial.
enum MockCaptureDeviceInputError: Error, Equatable {
    case denied
}

/// A capture device that is available but whose `input` throws, used to
/// exercise the permission-denied / input-construction failure path.
final class ThrowingCaptureDevice: CaptureDevice {
    var input: MockCaptureDeviceInput {
        get throws { throw MockCaptureDeviceInputError.denied }
    }
    static func `for`(mediaType: AVMediaType) -> Self? { Self() }
}
