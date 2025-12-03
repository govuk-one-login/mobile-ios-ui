import UIKit

public struct StyledIcon {
    public let icon: String
    public let font: UIFont?
    public let colour: UIColor?
    public let altText: String?

    public init(
        icon: String,
        font: UIFont? = DesignSystem.Font.Base.bodySemiBold,
        colour: UIColor? = DesignSystem.Color.GDSRow.icon,
        altText: String? = nil
    ) {
        self.icon = icon
        self.font = font
        self.colour = colour
        self.altText = altText
    }
}
