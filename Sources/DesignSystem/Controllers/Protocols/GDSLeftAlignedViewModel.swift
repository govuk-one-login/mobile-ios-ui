public protocol GDSLeftAlignedViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppear: ButtonAction?,
        didDismiss: ButtonAction?
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
        didAppear: ButtonAction? = nil,
        didDismiss: ButtonAction? = nil
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
