import UIKit

public struct GDSRowViewModel: ContentViewModel {
    public typealias ViewType = GDSRow
    
    var title: String
    var titleFont: UIFont?
    var titleColour: UIColor?
    var subtitle: String?
    var subtitleFont: UIFont?
    var subtitleColour: UIColor?
    var detail: String?
    var detailFont: UIFont?
    var detailColour: UIColor?
    var image: String?
    var imageAltText: String?
    var icon: String?
    var iconFont: UIFont?
    var iconColour: UIColor?
    var iconAltText: String?
    var accessibilityTraits: UIAccessibilityTraits
    var accessibilityHint: String?
    var type: RowType
    var action: (() async -> Void)?
    
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public var verticalPaddingValue: CGFloat {
        type.verticalPadding(hasSubtitle: subtitle != nil)
    }
        
    public init(
        title: String,
        titleFont: UIFont? = DesignSystem.Font.Base.body,
        titleColour: UIColor? = DesignSystem.Color.GDSRow.title,
        subtitle: String? = nil,
        subtitleFont: UIFont? = nil,
        subtitleColour: UIColor? = nil,
        detail: String? = nil,
        detailFont: UIFont? = DesignSystem.Font.Base.body,
        detailColour: UIColor? = DesignSystem.Color.GDSRow.detail,
        image: String? = nil,
        imageAltText: String? = nil,
        icon: String? = nil,
        iconFont: UIFont? = DesignSystem.Font.Base.bodySemiBold,
        iconColour: UIColor? = .tertiaryLabel,
        iconAltText: String? = nil,
        accessibilityTraits: UIAccessibilityTraits = [.button],
        accessibilityHint: String? = nil,
        type: RowType = .tall,
        action: (() async -> Void)? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        let defaultSubtitleFont = type.subtitleFont
        let defaultSubtitleColour = type.subtitleColour
        let openLinkHint = icon == "arrow.up.right" ? "Opens in web browser" : nil
        
        self.title = title
        self.titleFont = titleFont
        self.titleColour = titleColour
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont ?? defaultSubtitleFont
        self.subtitleColour = subtitleColour ?? defaultSubtitleColour
        self.detail = detail
        self.detailFont = detailFont
        self.detailColour = detailColour
        self.image = image
        self.imageAltText = imageAltText
        self.icon = icon
        self.iconFont = iconFont
        self.iconColour = iconColour
        self.iconAltText = iconAltText
        self.accessibilityTraits = accessibilityTraits
        self.accessibilityHint = accessibilityHint ?? openLinkHint
        self.type = type
        self.action = action
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
    
    }
}
