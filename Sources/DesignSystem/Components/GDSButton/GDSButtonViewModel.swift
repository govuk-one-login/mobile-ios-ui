import UIKit

public struct GDSButtonViewModel {
    public let title: TitleForState
    public let icon: IconForState?
    public let style: GDSButtonStyle
    public let buttonAction: ButtonAction
    public let haptic: Haptic?
    
    public init(
        title: String,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        buttonAction: ButtonAction,
        haptic: Haptic? = nil
    ) {
        self.title = TitleForState(stringLiteral: title)
        if let icon {
            self.icon = IconForState(normal: icon)
        } else {
            self.icon = nil
        }
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
    }
     
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
