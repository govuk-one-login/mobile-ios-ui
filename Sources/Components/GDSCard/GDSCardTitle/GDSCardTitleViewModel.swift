import UIKit

public struct GDSCardTitleViewModel: ContentViewModel {
    public typealias ViewType = GDSCardTitleView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let alignment: NSTextAlignment
    let accessibilityTraits: UIAccessibilityTraits?
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.title2Bold,
        alignment: NSTextAlignment = .left,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.alignment = alignment
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
