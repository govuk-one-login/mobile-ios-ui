import AVFoundation

public protocol CaptureSession: Sendable {
    associatedtype Input

    var isRunning: Bool { get }

    /// Creates a **new** preview layer bound to this session on every call.
    /// Callers must read this once and retain the result; reading it again
    /// yields a different, detached layer. `ScanningViewController` stores the
    /// result in `previewLayer` at init for exactly this reason.
    func makePreviewLayer() -> AVCaptureVideoPreviewLayer

    func startRunning()
    func stopRunning()
    
    func beginConfiguration()
    func commitConfiguration()
    
    func canAddInput(_ input: Input) -> Bool
    func addInput(_ input: Input)
    
    func canAddOutput(_ output: AVCaptureOutput) -> Bool
    func addOutput(_ output: AVCaptureOutput)
}

extension AVCaptureSession: CaptureSession {
    public func makePreviewLayer() -> AVCaptureVideoPreviewLayer {
        AVCaptureVideoPreviewLayer(session: self)
    }
}
