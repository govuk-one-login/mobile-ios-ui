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
    
    public convenience init(
        text: String? = nil,
        font: UIFont? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        numberOfLines: Int = 0
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        self.adjustsFontForContentSizeCategory = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
