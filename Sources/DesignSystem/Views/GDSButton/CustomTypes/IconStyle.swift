import UIKit

public struct IconStyle: Sendable, Equatable {
    public let icon: String
    public let font: UIFont?
    public let colour: UIColor?
    public let position: SymbolPosition
    public let accessibilityHint: String?
    
    public init(
        icon: String,
        font: UIFont? = nil,
        colour: UIColor? = nil,
        position: SymbolPosition,
        accessibilityHint: String? = nil
    ) {
        self.icon = icon
        self.font = font
        self.colour = colour
        self.position = position
        self.accessibilityHint = accessibilityHint
    }
    
    public init?(
        icon: String?,
        font: UIFont? = nil,
        colour: UIColor? = nil,
        position: SymbolPosition? = nil,
        accessibilityHint: String? = nil
    ) {
        if let icon {
            self.icon = icon
        } else { return nil }
        
        self.position = position ?? .trailing
        self.accessibilityHint = accessibilityHint
        self.font = font
        self.colour = colour
    }
}

extension IconStyle {
    public static let arrowUpRight: Self = IconStyle(
        icon: "arrow.up.right",
        position: .trailing,
        accessibilityHint: GDSLocalisedString(
            stringKey: "externalLinkAccessibilityHint",
            bundle: .designSystem
        ).value
    )
    
    public static let qrCode: Self = IconStyle(icon: "qrcode", position: .leading)
    public static let xMark: Self = IconStyle(icon: "xmark", position: .leading, accessibilityHint: "close")
}
