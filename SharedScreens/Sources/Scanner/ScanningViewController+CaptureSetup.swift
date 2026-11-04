import AVFoundation
import UIKit

extension ScanningViewController {
    func setupVideoDisplay() {
        guard let videoCaptureDevice = captureDevice.for(mediaType: .video),
              let videoInput = try? videoCaptureDevice.input as? CaptureSession.Input else {
            errorHandler(nil)
            return
        }
        guard captureSession.canAddInput(videoInput) else {
            assertionFailure("Can't add video input for detecting barcodes")
            errorHandler(nil)
            return
        }
        captureSession.addInput(videoInput)
    }

    func setupMetadataCapture() {
        let output = AVCaptureVideoDataOutput()
        guard captureSession.canAddOutput(output) else {
            assertionFailure("Can't add video output for detecting barcodes")
            errorHandler(nil)
            return
        }
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: processingQueue)

        captureSession.addOutput(output)

        videoDataOutput = output
    }

    func updatePreviewLayerFrame() {
        previewLayer.frame = cameraView.bounds
    }

    func setupInstructionLabel() {
        view.addSubview(instructionsLabel)
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    // Initiate the scanning process
    func startScanning() {
        if !captureSession.isRunning {
            let session = captureSession
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
    }

    // End the scanning process
    func stopScanning() {
        if captureSession.isRunning {
            // `stopRunning()` is a blocking AVFoundation call, so dispatch it off
            // the main thread to mirror `startScanning()` and avoid blocking the
            // main thread during `viewWillDisappear` / `cleanup()`.
            let session = captureSession
            DispatchQueue.global(qos: .userInitiated).async {
                session.stopRunning()
            }
        }
    }
}
