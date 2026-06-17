import UIKit

public struct GDSCardViewModel: ContentViewModel {
    public typealias ViewType = GDSCard
    
    let backgroundColour: UIColor
    let borderStyle: BorderStyle?
    let showShadow: Bool
    let dismissAction: DesignSystem.Action?
    
    public let accessibilityIdentifier: String?
    public let accessibilityTraits: UIAccessibilityTraits?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    let contentItems: [any ContentViewModel]
    
    public init(
        backgroundColour: UIColor = DesignSystem.Color.Backgrounds.card,
        borderStyle: BorderStyle? = nil,
        showShadow: Bool = false,
        dismissAction: DesignSystem.Action? = nil,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0),
        @ContentItemBuilder contentItems: () -> [any ContentViewModel]
    ) {
        self.backgroundColour = backgroundColour
        self.borderStyle = borderStyle
        self.showShadow = showShadow
        self.dismissAction = dismissAction
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.contentItems = contentItems()
    }
}
