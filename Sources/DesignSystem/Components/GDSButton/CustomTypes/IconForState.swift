import UIKit

public struct IconForState: Sendable, Equatable {
    private let normal: IconStyle
    private let highlighted: IconStyle?
    private let selected: IconStyle?
    private let focused: IconStyle?
    private let disabled: IconStyle?
    private let selectedHighlighted: IconStyle?
    private let focusedHighlighted: IconStyle?
    
    var isSelectable: Bool {
        (selected != nil) || (selectedHighlighted != nil)
    }
    
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
    
    public func forState(_ state: UIControl.State) -> IconStyle {
        switch state {
        case [.selected, .highlighted]:
            return selectedHighlighted ?? normal
        case [.focused, .highlighted]:
            return focusedHighlighted ?? normal
        case [.focused, .selected]:
            return selected ?? normal
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

extension IconForState {
    public static let arrowUpRight: Self = IconForState(normal: IconStyle.arrowUpRight)
    public static let qrCode: Self = IconForState(normal: IconStyle.qrCode)
    public static let xMark: Self = IconForState(normal: .xMark)
}

extension IconForState: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(normal: IconStyle(icon: value, position: .trailing))
    }
}
