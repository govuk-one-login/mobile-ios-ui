@available(*, deprecated, message: "Use GDSScreenViewModel instead with GDSErrorIconTitle content view")

public protocol GDSErrorScreenViewModel: BaseViewModel, GDSScreenViewModel {
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

extension GDSErrorScreenViewModel {
    public init(
        icon: GDSImageViewModel,
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
            screenStyle: .error,
            body: [icon] + body,
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
