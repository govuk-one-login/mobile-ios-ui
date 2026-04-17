import UIKit

public typealias TitleConfig = (font: UIFont, isHeader: Bool)

public enum ListStyle: String {
    case numbered
    case bulleted
}

/// Example on creating linked text with icon
///
///  
///```swift
///GDSLocalisedString(
///    stringLiteral: "This is a linked phrase",
///    stringAttributes: .init(
///        symbol: UIImage(
///            systemName: "arrow.up.right",
///            withConfiguration: UIImage.SymbolConfiguration(font: DesignSystem.Font.Base.body)
///        )?.withTintColor(DesignSystem.Color.Links.default, renderingMode: .alwaysOriginal),
///        position: .trailing,
///        attributes: [
///            ("This is a ",
///             [.foregroundColor: DesignSystem.Color.Text.primary,
///              .font: DesignSystem.Font.Base.body]
///            ),
///            ("linked phrase",
///             [.foregroundColor: DesignSystem.Color.Links.default,
///              .font: DesignSystem.Font.Base.body,
///              .link: URL(string: "https://www.gov.uk")!]
///            )
///        ]
///    )
///)
///```


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
}
