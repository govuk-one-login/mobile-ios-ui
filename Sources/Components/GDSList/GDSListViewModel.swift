import UIKit

public typealias TitleConfig = (font: UIFont, isHeader: Bool)

public enum ListStyle: String {
    case numbered
    case bulleted
}

@MainActor
public struct GDSListViewModel: ContentViewModel {
    public typealias ViewType = GDSList
        
    public var title: GDSLocalisedString?
    public var titleConfig: TitleConfig?
    public var items: [GDSLocalisedString]
    public var style: ListStyle
    public var accessibilityIdentifier: String?
    public var accessibilityTraits: UIAccessibilityTraits?
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString? = nil,
        titleConfig: TitleConfig? = nil,
        items: [GDSLocalisedString],
        style: ListStyle,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = nil,
        horizontal: HorizontalPadding? = nil,
    ) {
        self.title = title
        self.titleConfig = titleConfig
        self.items = items
        self.style = style
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontal
    }
}
