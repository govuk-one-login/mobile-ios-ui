import UIKit

@MainActor
protocol OrientationProvider {
    var orientation: UIDeviceOrientation { get }
}

extension UIDevice: OrientationProvider { }
