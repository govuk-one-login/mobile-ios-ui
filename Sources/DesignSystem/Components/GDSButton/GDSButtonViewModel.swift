public struct GDSButtonViewModel {
    public let title: TitleForState
    public let icon: IconStyle?
    public let style: GDSButtonStyle
    public let buttonAction: ButtonAction
    public let haptic: Haptic?
     
    public init(
        title: TitleForState,
        icon: IconStyle? = nil,
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
