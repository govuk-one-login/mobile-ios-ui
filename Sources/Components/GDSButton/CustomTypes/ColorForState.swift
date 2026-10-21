import UIKit

public struct ColorForState: Equatable {
    private let normal: UIColor
    private let highlighted: UIColor?
    private let selected: UIColor?
    private let focused: UIColor?
    private let disabled: UIColor?
    private let selectedHighlighted: UIColor?
    private let focusedHighlighted: UIColor?
    public let loading: UIColor?
    
    var isSelectable: Bool {
        (selected != nil) || (selectedHighlighted != nil)
    }
    
    public init(
        normal: UIColor,
        highlighted: UIColor? = nil,
        selected: UIColor? = nil,
        focused: UIColor?,
        disabled: UIColor? = nil,
        selectedHighlighted: UIColor? = nil,
        focusedHighlighted: UIColor? = nil,
        loading: UIColor? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.focused = focused
        self.disabled = disabled
        self.selectedHighlighted = selectedHighlighted
        self.focusedHighlighted = focusedHighlighted
        self.loading = loading
    }
    
    public func forState(_ state: UIControl.State) -> UIColor {
        switch state {
        case [.selected, .highlighted]:
            return selectedHighlighted ?? highlighted ?? normal
        case [.focused, .highlighted]:
            return focusedHighlighted ?? highlighted ?? normal
        case [.focused, .selected]:
            return focused ?? normal
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
