import UIKit

public struct GDSCardViewModel: ContentViewModel {
    let backgroundColour: UIColor
    let borderStyle: BorderStyle?
    let showShadow: Bool
    let dismissAction: DesignSystem.Action?
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    let contentItems: [any ContentViewModel]
    
    public init(
        backgroundColour: UIColor = DesignSystem.Color.Backgrounds.card,
        borderStyle: BorderStyle? = nil,
        showShadow: Bool = false,
        dismissAction: DesignSystem.Action? = nil,
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
    
    public func createUIView() -> UIView {
        GDSCard(viewModel: self)
    }
}
