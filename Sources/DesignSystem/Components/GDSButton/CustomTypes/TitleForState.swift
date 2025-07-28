import UIKit

public struct TitleForState {
    private let normal: String
    private let highlighted: String?
    private let selected: String?
    private let focused: String?
    private let selectedHighlighted: String?
    private let focusedHighlighted: String?
    private let disabled: String?
    
    var isSelectable: Bool {
        (selected != nil) || (selectedHighlighted != nil)
    }
    
    public init(
        normal: String,
        highlighted: String? = nil,
        selected: String? = nil,
        focused: String? = nil,
        selectedHighlighted: String? = nil,
        focusedHighlighted: String? = nil,
        disabled: String? = nil
    ) {
        self.normal = normal
        self.disabled = disabled
        self.highlighted = highlighted
        self.selected = selected
        self.focused = focused
        self.selectedHighlighted = selectedHighlighted
        self.focusedHighlighted = focusedHighlighted
    }
    
    public func title(for state: UIControl.State) -> String {
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

extension TitleForState: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(normal: value)
    }
}
