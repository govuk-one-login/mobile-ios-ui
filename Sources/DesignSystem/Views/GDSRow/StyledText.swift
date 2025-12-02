import UIKit

public struct StyledText {
    public let text: String
    public let font: UIFont?
    public let colour: UIColor?

    public init(
        text: String,
        font: UIFont? = nil,
        colour: UIColor? = nil
    ) {
        self.text = text
        self.font = font
        self.colour = colour
    }
}
