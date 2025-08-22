import UIKit

public struct IconStyle: Sendable, Equatable {
    public let icon: String
    public let position: SymbolPosition
    public let accessibilityHint: String?
    
    public init(
        icon: String,
        position: SymbolPosition,
        accessibilityHint: String? = nil
    ) {
        self.icon = icon
        self.position = position
        self.accessibilityHint = accessibilityHint
    }
    
    public init?(
        icon: String?,
        position: SymbolPosition? = nil,
        accessibilityHint: String? = nil
    ) {
        if let icon {
            self.icon = icon
        } else { return nil }
        
        self.position = position ?? .trailing
        
        self.accessibilityHint = accessibilityHint
    }
}

extension IconStyle {
    public static let arrowUpRight: Self = IconStyle(icon: "arrow.up.right", position: .trailing, accessibilityHint: "opens in web browser")
    public static let qrCode: Self = IconStyle(icon: "qrcode", position: .leading)
    public static let xmark: Self = IconStyle(icon: "xmark", position: .leading, accessibilityHint: "dismiss")
}
