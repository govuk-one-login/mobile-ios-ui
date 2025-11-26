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
    var type: RowType
    
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public var verticalPaddingValue: CGFloat {
        type.verticalPadding(hasSubtitle: subtitle != nil)
    }
        
    public init(
        title: String,
        titleFont: UIFont? = DesignSystem.Font.Base.body,
        titleColour: UIColor? = .label,
        subtitle: String? = nil,
        subtitleFont: UIFont? = nil,
        subtitleColour: UIColor? = nil,
        detail: String? = nil,
        detailFont: UIFont? = DesignSystem.Font.Base.body,
        detailColour: UIColor? = .secondaryLabel,
        image: String? = nil,
        imageAltText: String? = nil,
        icon: String? = nil,
        iconFont: UIFont? = DesignSystem.Font.Base.bodySemiBold,
        iconColour: UIColor? = .tertiaryLabel,
        type: RowType = .tall,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        let defaultSubtitleFont = type.subtitleFont
        let defaultSubtitleColour = type.subtitleColour
        
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
        self.type = type
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
        
}

public enum RowType {
    case regular
    case tall
    
    public var minRowHeight: CGFloat {
        switch self {
        case .regular:
            44
        case .tall:
            60
        }
    }
    
    public var subtitleFont: UIFont {
        switch self {
        case .regular:
            DesignSystem.Font.Base.footnote
        case .tall:
            DesignSystem.Font.Base.subheadline
        }
    }
    
    public var subtitleColour: UIColor {
        switch self {
        case .regular:
                .label
        case .tall:
                .secondaryLabel
        }
    }
    
    public func verticalPadding(hasSubtitle: Bool) -> CGFloat {
        switch self {
        case .regular:
            hasSubtitle ? 4 : 11
        case .tall:
            hasSubtitle ? 9 : 19
        }
    }
}
