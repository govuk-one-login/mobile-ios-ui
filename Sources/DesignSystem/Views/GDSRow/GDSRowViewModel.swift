import UIKit

public struct GDSRowViewModel: ContentViewModel {
    public typealias ViewType = GDSRow
    
    var title: String
    var titleFont: UIFont?
    var subtitle: String?
    var detail: String?
    var image: String?
    var icon: String?
    var type: RowType
    var isGrouped: Bool
    
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public var verticalPaddingValue: CGFloat {
        type.verticalPadding(hasSubtitle: subtitle != nil)
    }
        
    public init(
        title: String = "HM Armed Forces Veteran Card",
        titleFont: UIFont? = nil,
        subtitle: String? = "Inactive since 30 October 2025",
        detail: String? = "Detail",
        image: String? = "exampleImage",
        icon: String? = "arrow.up.right",
        type: RowType = .tall,
        isGrouped: Bool = false,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.subtitle = subtitle
        self.detail = detail
        self.image = image
        self.icon = icon
        self.type = type
        self.isGrouped = isGrouped
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
    
    public func verticalPadding(hasSubtitle: Bool) -> CGFloat {
        switch self {
        case .regular:
            hasSubtitle ? 4 : 11
        case .tall:
            hasSubtitle ? 9 : 19
        }
    }
}
