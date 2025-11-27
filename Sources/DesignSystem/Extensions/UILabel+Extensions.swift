import UIKit

extension UILabel {
    convenience public init(colour: UIColor, alignment: NSTextAlignment = .left) {
        self.init()
        self.adjustsFontForContentSizeCategory = true
        self.numberOfLines = 0
        self.textAlignment = alignment
        self.lineBreakMode = .byWordWrapping
        self.textColor = colour
    }
}
