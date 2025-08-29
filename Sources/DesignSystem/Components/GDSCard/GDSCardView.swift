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
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0),
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
