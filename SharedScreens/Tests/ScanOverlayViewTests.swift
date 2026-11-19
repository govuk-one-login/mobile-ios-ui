@testable import DesignSystem
@testable import SharedScreens
import Testing
import UIKit

@MainActor
struct ScanOverlayViewTests {
    private let size: CGFloat = 100

    private func makeSUT() -> ScanOverlayView {
        ScanOverlayView(frame: .init(x: 0, y: 0, width: size, height: size * 2))
    }

    @Test
    func viewfinderSizesPortrait() {
        let sut = makeSUT()
        #expect(sut.reticleSize.width == size * 0.7)
        #expect(sut.viewfinderRect == CGRect(x: 15, y: 65, width: 70, height: 70))
    }

    @Test
    func viewfinderSizesLandscape() {
        let sut = makeSUT()
        sut.orientationProvider = LandscapeOrientationProvider()

        #expect(sut.reticleSize.height == size * 1.4)
        #expect(sut.viewfinderRect == CGRect(x: -20, y: 30, width: 140, height: 140))
    }

    @Test
    func willMoveToSuperviewConfiguresOverlayLayer() {
        let sut = makeSUT()
        let parent = UIView(frame: .init(origin: .zero, size: .init(width: 300, height: 800)))
        parent.addSubview(sut)

        #expect(sut.overlayLayer.fillRule == .evenOdd)
        #expect(sut.overlayLayer.opacity == 0.5)
        #expect(sut.layer.sublayers?.contains(sut.overlayLayer) ?? false)
    }

    @Test
    func layoutSubviewsUsesScannerBackground() {
        let sut = makeSUT()
        sut.layoutSubviews()
        #expect(sut.overlayLayer.frame == sut.frame)
        #expect(sut.overlayLayer.fillColor == UIColor.scannerBackground.cgColor)
        #expect(sut.overlayLayer.opacity == 0.7)
    }
}

@MainActor
private struct LandscapeOrientationProvider: OrientationProvider {
    let orientation: UIDeviceOrientation = .landscapeLeft
}
