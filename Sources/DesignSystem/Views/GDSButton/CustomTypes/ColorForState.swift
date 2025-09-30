import UIKit

public struct ColorForState: Equatable {
    private let normal: UIColor
    private let highlighted: UIColor?
    private let selected: UIColor?
    private let focused: UIColor?
    private let disabled: UIColor?
    private let selectedHighlighted: UIColor?
    private let focusedHighlighted: UIColor?
    
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
        focusedHighlighted: UIColor? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.focused = focused
        self.disabled = disabled
        self.selectedHighlighted = selectedHighlighted
        self.focusedHighlighted = focusedHighlighted
    }
    
    public func forState(_ state: UIControl.State) -> UIColor {
        switch state {
        case [.selected, .highlighted]:
            return selectedHighlighted ?? normal
        case [.focused, .highlighted]:
            return focusedHighlighted ?? normal
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
