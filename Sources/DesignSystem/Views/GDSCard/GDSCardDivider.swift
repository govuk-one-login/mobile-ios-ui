import UIKit

public struct GDSCardDividerViewModel: ContentViewModel {
    public typealias ViewType = GDSCardDividerView
    
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

public final class GDSCardDividerView: UIView, ContentView {
    public init(viewModel: GDSCardDividerViewModel) {
        super.init(frame: .zero)
        
        self.backgroundColor = viewModel.colour
        self.heightAnchor.constraint(equalToConstant: viewModel.height).isActive = true
        self.accessibilityIdentifier = "divider"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
