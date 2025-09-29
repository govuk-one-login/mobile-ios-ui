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

@available(*, deprecated, renamed: "GDSDividerView", message: "to be removed October 2025")
public typealias GDSCardDividerView = GDSDividerView

public final class GDSDividerView: UIView, ContentView {
    public init(viewModel: GDSDividerViewModel) {
        super.init(frame: .zero)
        
        self.backgroundColor = viewModel.colour
        self.heightAnchor.constraint(equalToConstant: viewModel.height).isActive = true
        self.accessibilityIdentifier = "gds-divider-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
