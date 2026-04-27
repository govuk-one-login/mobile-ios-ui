import UIKit

@available(*, deprecated, renamed: "GDSDividerViewModel", message: "to be removed October 2025")
public typealias GDSCardDividerViewModel = GDSDividerViewModel

public struct GDSDividerViewModel: ContentViewModel {
    public typealias ViewType = GDSDividerView
    
    let height: CGFloat
    let colour: UIColor
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        height: CGFloat = 1,
        colour: UIColor = DesignSystem.Color.Dividers.card,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .leading(16)
    ) {
        self.height = height
        self.colour = colour
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
