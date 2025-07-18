import UIKit

public struct ColorForState {
    public let normal: UIColor
    public let highlighted: UIColor?
    public let selected: UIColor?
    public let focused: UIColor?
    public let disabled: UIColor?
    public let selectedHighlighted: UIColor?
    public let focusedHighlighted: UIColor?
    
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
}
