import UIKit

public typealias TitleConfig = (font: UIFont, isHeader: Bool)

public enum ListStyle {
    case numbered
    case bulleted
    
    var identifierPrefix: String {
        switch self {
        case .numbered:
            return "numbered"
        case .bulleted:
            return "bulleted"
        }
    }
}

@MainActor
public struct GDSListViewModel: ContentViewModel {
    public typealias ViewType = GDSList
        
    public var title: GDSLocalisedString?
    public var titleConfig: TitleConfig?
    public var items: [GDSLocalisedString]
    public var style: ListStyle
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString? = nil,
        titleConfig: TitleConfig? = nil,
        items: [GDSLocalisedString],
        style: ListStyle,
        verticalPadding: VerticalPadding? = nil,
        horizontal: HorizontalPadding? = nil,
    ) {
        self.title = title
        self.titleConfig = titleConfig
        self.items = items
        self.style = style
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontal
    }
    
    public func createUIView() -> UIView {
        GDSList(viewModel: self)
    }
}
