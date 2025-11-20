import UIKit

public struct GDSRowViewModel: ContentViewModel {
    public typealias ViewType = GDSRow
    
    var title: String
    var titleFont: UIFont?
    var subtitle: String?
    var detail: String?
    var image: UIImage?
    var icon: String?
    
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public init(
        title: String = "HM Armed Forces Veteran Card",
        titleFont: UIFont? = nil,
        subtitle: String? = nil,
        detail: String? = nil,
        image: UIImage? = nil,
        icon: String? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.subtitle = subtitle
        self.detail = detail
        self.image = image
        self.icon = icon
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
