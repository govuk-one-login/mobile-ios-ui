import AVFoundation
import UIKit

private enum PulseAnimation {
    static let scaleDelta: CGFloat = 0.05 // Pulse ±5% from center
    static let duration: TimeInterval = 1.0
}

extension ScanningViewController {
    /// Keeps the scanner title legible over the darkened camera preview without
    /// mutating the shared navigation bar or applying a blur effect such as systemChromeMaterial.
    func configureNavigationAppearance() {
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

    func updateRegionOfInterest() {
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

    func stopAnimation() {
        imageView.layer.removeAllAnimations()
        imageView.transform = .identity
    }

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
