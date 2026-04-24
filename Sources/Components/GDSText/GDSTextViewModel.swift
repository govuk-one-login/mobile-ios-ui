@available(*, deprecated, renamed: "GDSTextViewModel", message: "to be removed October 2025")
public typealias GDSCardTextViewModel = GDSTextViewModel

public struct GDSTextViewModel: ContentViewModel {
    public typealias ViewType = GDSTextView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let textColor: UIColor
    let alignment: NSTextAlignment
    let accessibilityTraits: UIAccessibilityTraits?
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.body,
        textColor: UIColor = DesignSystem.Color.Text.primary,
        alignment: NSTextAlignment = .left,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.textColor = textColor
        self.alignment = alignment
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
