import UIKit

public struct TitleForState {
    public let normal: String
    
    public var highlighted: String {
        internalHighlighted ?? normal
    }
    
    public var selected: String {
        internalSelected ?? normal
    }
    
    public var focused: String {
        internalFocused ?? normal
    }
    
    public var selectedHighlighted: String {
        internalSelectedHighlighted ?? normal
    }
    
    public var focusedHighlighted: String {
        internalHighlighted ?? normal
    }
    
    public var disabled: String?
    
    private let internalHighlighted: String?
    private let internalSelected: String?
    private let internalFocused: String?
    private let internalSelectedHighlighted: String?
    private let internalFocusedHighlighted: String?
    
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
        self.internalHighlighted = highlighted
        self.internalSelected = selected
        self.internalFocused = focused
        self.internalSelectedHighlighted = selectedHighlighted
        self.internalFocusedHighlighted = focusedHighlighted
    }
}
