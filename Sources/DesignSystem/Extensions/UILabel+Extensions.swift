import UIKit

extension UILabel {
    public convenience init(
        text: String? = nil,
        font: UIFont? = nil,
        colour: UIColor? = nil,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        numberOfLines: Int = 0
    ) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = colour
        self.textAlignment = alignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        self.adjustsFontForContentSizeCategory = true
    }
}
