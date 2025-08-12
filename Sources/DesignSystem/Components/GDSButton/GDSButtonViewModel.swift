import UIKit

public struct GDSButtonViewModel {
    public let title: TitleForState
    public let icon: IconForState?
    public let style: GDSButtonStyle
    public let buttonAction: ButtonAction
    public let haptic: Haptic?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: String,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        buttonAction: ButtonAction,
        haptic: Haptic? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
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
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
     
    public init(
        title: TitleForState,
        icon: IconForState? = nil,
        style: GDSButtonStyle,
        buttonAction: ButtonAction,
        haptic: Haptic? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension GDSButtonViewModel: ContentItem {
    public var uiView: UIView {
        GDSButton(viewModel: self)
    }
}
