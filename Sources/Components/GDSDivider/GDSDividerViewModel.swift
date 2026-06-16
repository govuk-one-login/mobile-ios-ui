import UIKit

public struct GDSDividerViewModel: ContentViewModel {
    public typealias ViewType = GDSDividerView
    
    let height: CGFloat
    let colour: UIColor
    
    public let accessibilityIdentifier: String?
    public let accessibilityTraits: UIAccessibilityTraits?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        height: CGFloat = 1,
        colour: UIColor = DesignSystem.Color.Dividers.card,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .leading(16)
    ) {
        self.height = height
        self.colour = colour
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
