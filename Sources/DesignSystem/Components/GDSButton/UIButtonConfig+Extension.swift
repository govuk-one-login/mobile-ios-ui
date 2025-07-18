import UIKit

extension UIButton.Configuration {
    static var primary: Self {
        var config = UIButton.Configuration.borderedProminent()
        config.imagePlacement = .top
        config.imagePadding = .zero
        return config
    }
    
    static var secondary: Self {
        var config = UIButton.Configuration.borderedProminent()
        config.imagePlacement = .top
        return config
    }
}
