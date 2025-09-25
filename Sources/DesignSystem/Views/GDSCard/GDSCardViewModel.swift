import UIKit

public struct GDSCardViewModel: ContentViewModel {
    public typealias ViewType = GDSCard
    
    public let backgroundColour: UIColor
    public let borderStyle: BorderStyle?
    public let showShadow: Bool
    public let dismissAction: Action?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    public let contentItems: [any ContentViewModel]
    
    public init(
        backgroundColour: UIColor = DesignSystem.Color.Backgrounds.card,
        borderStyle: BorderStyle? = nil,
        showShadow: Bool = false,
        dismissAction: Action? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0),
        @ContentItemBuilder contentItems: () -> [any ContentViewModel]
    ) {
        self.backgroundColour = backgroundColour
        self.borderStyle = borderStyle
        self.showShadow = showShadow
        self.dismissAction = dismissAction
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.contentItems = contentItems()
    }
}
