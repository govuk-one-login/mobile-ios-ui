import UIKit

public struct GDSTextViewModel: ContentViewModel {
    public typealias ViewType = GDSTextView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let textColor: UIColor
    let alignment: NSTextAlignment

    public let accessibilityTraits: UIAccessibilityTraits?
    public let accessibilityIdentifier: String?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.body,
        textColor: UIColor = DesignSystem.Color.Text.primary,
        alignment: NSTextAlignment = .left,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        accessibilityIdentifier: String? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.textColor = textColor
        self.alignment = alignment
        self.accessibilityTraits = accessibilityTraits
        self.accessibilityIdentifier = accessibilityIdentifier
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
