import UIKit

public struct ContentCardDividerViewModel {
    let height: CGFloat
    let colour: UIColor
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        height: CGFloat,
        colour: UIColor,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .trailing(0)
    ) {
        self.height = height
        self.colour = colour
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension ContentCardDividerViewModel: ContentItem {
    public var uiView: UIView {
        let view = UIView()
        view.backgroundColor = colour
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.accessibilityIdentifier = "divider"
        return view
    }
}
