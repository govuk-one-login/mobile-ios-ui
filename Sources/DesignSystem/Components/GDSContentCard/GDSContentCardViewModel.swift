import UIKit

public struct GDSContentCardViewModel {
    public let items: [ContentItem]
    public let showShadow: Bool
    public let dismissAction: ButtonAction?
    
    public init(
        items: [ContentItem],
        showShadow: Bool,
        dismissAction: ButtonAction? = nil
    ) {
        self.items = items
        self.showShadow = showShadow
        self.dismissAction = dismissAction
    }
}

extension GDSContentCardViewModel: ContentItem {
    public var uiView: UIView {
        GDSContentCardView(viewModel: self)
    }
}
