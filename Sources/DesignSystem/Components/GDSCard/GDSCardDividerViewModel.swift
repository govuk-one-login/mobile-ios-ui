import UIKit

public struct GDSCardDividerViewModel {
    let height: CGFloat
    let colour: UIColor
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        height: CGFloat,
        colour: UIColor,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .leading(16)
    ) {
        self.height = height
        self.colour = colour
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension GDSCardDividerViewModel: ContentItem {
    public var uiView: UIView {
        let view = UIView()
        view.backgroundColor = colour
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.accessibilityIdentifier = "divider"
        return view
    }
}
