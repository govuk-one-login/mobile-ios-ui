import UIKit

public struct IconForState: Sendable {
    private let normal: IconStyle
    private let highlighted: IconStyle?
    private let selected: IconStyle?
    private let focused: IconStyle?
    private let disabled: IconStyle?
    private let selectedHighlighted: IconStyle?
    private let focusedHighlighted: IconStyle?
    
    public init(
        normal: IconStyle,
        highlighted: IconStyle? = nil,
        selected: IconStyle? = nil,
        focused: IconStyle? = nil,
        disabled: IconStyle? = nil,
        selectedHighlighted: IconStyle? = nil,
        focusedHighlighted: IconStyle? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.focused = focused
        self.disabled = disabled
        self.selectedHighlighted = selectedHighlighted
        self.focusedHighlighted = focusedHighlighted
    }
    
    public func icon(for state: UIControl.State) -> IconStyle {
        switch state {
        case [.selected, .highlighted]:
            return selectedHighlighted ?? normal
        case [.focused, .highlighted]:
            return focusedHighlighted ?? normal
        case .selected:
            return selected ?? normal
        case .highlighted:
            return highlighted ?? normal
        case .focused:
            return focused ?? normal
        case .disabled, [.focused, .disabled]:
            return disabled ?? normal
        default:
            return normal
        }
    }
}

public struct IconStyle: Sendable {
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
}

extension IconForState {
    public static let arrowUpRight: Self = IconForState(normal: IconStyle.arrowUpRight)
    public static let qrCode: Self = IconForState(normal: IconStyle.qrCode)
}

extension IconStyle {
    public static let arrowUpRight: Self = IconStyle(icon: "arrow.up.right", position: .trailing, accessibilityHint: "opens in your web browser")
    public static let qrCode: Self = IconStyle(icon: "qrcode", position: .leading)
}
