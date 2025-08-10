import UIKit

extension UIButton.Configuration {
    static var gds: Self {
        var config = UIButton.Configuration.borderedProminent()
        config.imagePlacement = .top
        return config
    }
    
    static var closeButton: Self {
        var config = UIButton.Configuration.borderless()
        config.contentInsets.top = 0
        return config
    }
}
