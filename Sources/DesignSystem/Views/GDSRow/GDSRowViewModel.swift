import UIKit

public struct GDSRowViewModel: ContentViewModel, Identifiable {
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
    
    public let id = UUID()
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public var verticalPaddingValue: CGFloat {
        type.verticalPadding(hasSubtitle: subtitle != nil)
    }
        
    public init(
        titleConfig: StyledText,
        subtitleConfig: StyledText? = nil,
        detailConfig: StyledText? = nil,
        image: String? = nil,
        imageAltText: String? = nil,
        iconConfig: StyledIcon? = nil,
        accessibilityTraits: UIAccessibilityTraits = [],
        accessibilityHint: String? = nil,
        type: RowType = .tall,
        action: (() async -> Void)? = nil
    ) {
        let defaultSubtitleFont = type.subtitleFont
        let defaultSubtitleColour = type.subtitleColour
        let openLinkHint = iconConfig?.icon == "arrow.up.right" ? "Opens in web browser" : nil
        
        self.title = titleConfig.text
        self.titleFont = titleConfig.font ?? DesignSystem.Font.Base.body
        self.titleColour = titleConfig.colour ?? DesignSystem.Color.GDSRow.title
        self.subtitle = subtitleConfig?.text
        self.subtitleFont = subtitleConfig?.font ?? defaultSubtitleFont
        self.subtitleColour = subtitleConfig?.colour ?? defaultSubtitleColour
        self.detail = detailConfig?.text
        self.detailFont = detailConfig?.font ?? DesignSystem.Font.Base.body
        self.detailColour = detailConfig?.colour ?? DesignSystem.Color.GDSRow.detail
        self.image = image
        self.imageAltText = imageAltText
        self.icon = iconConfig?.icon
        self.iconFont = iconConfig?.font
        self.iconColour = iconConfig?.colour
        self.iconAltText = iconConfig?.altText
        self.accessibilityTraits = accessibilityTraits
        self.accessibilityHint = accessibilityHint ?? openLinkHint
        self.type = type
        self.action = action
    }
}
