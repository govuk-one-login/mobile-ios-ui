import UIKit

public struct GDSCardViewModel {
    public let content: [ContentItem]
    public let backgroundColour: UIColor
    public let showShadow: Bool
    public let dismissAction: ButtonAction?
    
    public init(
        items: [ContentItem],
        backgroundColour: UIColor = .systemBackground,
        showShadow: Bool,
        dismissAction: ButtonAction? = nil
    ) {
        self.content = items
        self.backgroundColour = backgroundColour
        self.showShadow = showShadow
        self.dismissAction = dismissAction
    }
}

extension GDSCardViewModel: ContentItem {
    public var uiView: UIView {
        GDSCardView(viewModel: self)
    }
}
