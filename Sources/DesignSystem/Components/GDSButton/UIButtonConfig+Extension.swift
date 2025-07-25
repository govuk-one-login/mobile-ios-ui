import UIKit

extension UIButton.Configuration {
    static var gds: Self {
        var config = UIButton.Configuration.borderedProminent()
        config.imagePlacement = .top
        return config
    }
}
