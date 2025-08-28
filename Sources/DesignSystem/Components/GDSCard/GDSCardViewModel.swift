import UIKit

public struct GDSCardViewModel: ContentViewModel {
    public typealias ViewType = GDSCard
    
    public let backgroundColour: UIColor
    public let showShadow: Bool
    public let dismissAction: ButtonAction?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    public let contentItems: [any ContentViewModel]
    
    public init(
        backgroundColour: UIColor = DesignSystem.Color.Backgrounds.card,
        showShadow: Bool = false,
        dismissAction: ButtonAction? = nil,
        verticalPadding: VerticalPadding? = nil,
        horizontalPadding: HorizontalPadding? = nil,
        @ContentItemBuilder contentItems: () -> [any ContentViewModel]
    ) {
        self.backgroundColour = backgroundColour
        self.showShadow = showShadow
        self.dismissAction = dismissAction
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.contentItems = contentItems()
    }
}


@resultBuilder
public struct ContentItemBuilder {
    public static func buildBlock(_ components: [any ContentViewModel]...) -> [any ContentViewModel] {
        components.flatMap { $0 }
    }

    /// Add support for both single and collections of constraints.
    public static func buildExpression(_ expression: any ContentViewModel) -> [any ContentViewModel] {
        [expression]
    }

    public static func buildExpression(_ expression: [any ContentViewModel]) -> [any ContentViewModel] {
        expression
    }
}
