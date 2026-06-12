import UIKit

public struct GDSButtonViewModel: ContentViewModel, ControlViewModel {
    public typealias ViewType = GDSButton
    
    public let title: TitleForState
    public let icon: IconForState?
    public let style: GDSButtonStyle
    public let buttonAction: DesignSystem.Action
    public let haptic: Haptic?
    public let accessibilityHint: String?
    public let enableState: EnableState?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: String,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        buttonAction: DesignSystem.Action,
        haptic: Haptic? = nil,
        accessibilityHint: String? = nil,
        enableState: Bool? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
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
        self.accessibilityHint = accessibilityHint
        
        if let enableState {
            self.enableState = EnableState(enableState)
        } else {
            self.enableState = nil
        }
        
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
     
    public init(
        title: TitleForState,
        icon: IconForState? = nil,
        style: GDSButtonStyle,
        buttonAction: DesignSystem.Action,
        haptic: Haptic? = nil,
        accessibilityHint: String? = nil,
        enableState: Bool? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
        self.accessibilityHint = accessibilityHint
        
        if let enableState {
            self.enableState = EnableState(enableState)
        } else {
            self.enableState = nil
        }
        
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
