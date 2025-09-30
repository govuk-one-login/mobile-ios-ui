public protocol GDSLeftAlignedViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppear: DesignSystem.Action?,
        didDismiss: DesignSystem.Action?
    )
}

extension GDSLeftAlignedViewModel {
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString? = nil,
        backButtonTitle: GDSLocalisedString? = nil,
        backButtonIsHidden: Bool = true,
        didAppear: DesignSystem.Action? = nil,
        didDismiss: DesignSystem.Action? = nil
    ) {
        self = Self(
            screenStyle: .topLeading,
            body: body,
            movableFooter: movableFooter,
            footer: footer,
            rightBarButtonTitle: rightBarButtonTitle,
            backButtonTitle: backButtonTitle,
            backButtonIsHidden: backButtonIsHidden,
            didAppear: didAppear,
            didDismiss: didDismiss
        )
    }
}
