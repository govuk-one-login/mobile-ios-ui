import UIKit

extension UIViewController {
    func attachToWindow() {
        let window = UIWindow()
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}
