import UIKit

public struct GDSButtonViewModel {
    public let title: TitleForState
    public let icon: IconForState?
    public let style: GDSButtonStyle
    public let buttonAction: ButtonAction
    public let haptic: Haptic?
     
    public init(
        title: TitleForState,
        icon: IconForState? = nil,
        style: GDSButtonStyle,
        buttonAction: ButtonAction,
        haptic: Haptic? = nil
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
    }
}

extension GDSButtonViewModel: ContentItem {
    public var uiView: UIView {
        GDSButton(viewModel: self)
    }
}
