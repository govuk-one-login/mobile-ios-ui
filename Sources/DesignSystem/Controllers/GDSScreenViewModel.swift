import UIKit

@MainActor
public protocol GDSScreenViewModel {
    var screenStyle: GDSScreenStyle { get }
    var body: [any ContentViewModel] { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

public protocol GDSCentreAlignedViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    )
}

extension GDSCentreAlignedViewModel {
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString? = nil,
        backButtonIsHidden: Bool = true,
        didAppearAction: (() -> Void)? = nil,
        didDismissAction: (() -> Void)? = nil
    ) {
        self = Self(
            screenStyle: .topCentred,
            body: body,
            movableFooter: movableFooter,
            footer: footer,
            rightBarButtonTitle: rightBarButtonTitle,
            backButtonIsHidden: backButtonIsHidden,
            didAppearAction: didAppearAction,
            didDismissAction: didDismissAction
        )
    }
}

public protocol GDSLeftAlignedViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    )
}

extension GDSLeftAlignedViewModel {
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString? = nil,
        backButtonIsHidden: Bool = true,
        didAppearAction: (() -> Void)? = nil,
        didDismissAction: (() -> Void)? = nil
    ) {
        self = Self(
            screenStyle: .topLeadingAligned,
            body: body,
            movableFooter: movableFooter,
            footer: footer,
            rightBarButtonTitle: rightBarButtonTitle,
            backButtonIsHidden: backButtonIsHidden,
            didAppearAction: didAppearAction,
            didDismissAction: didDismissAction
        )
    }
}

public protocol GDSErrorScreenViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    )
}

extension GDSErrorScreenViewModel {
    public init(
        icon: GDSImageViewModel,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString? = nil,
        backButtonIsHidden: Bool = true,
        didAppearAction: (() -> Void)? = nil,
        didDismissAction: (() -> Void)? = nil
    ) {
        self = Self(
            screenStyle: .error,
            body: [icon] + body,
            movableFooter: movableFooter,
            footer: footer,
            rightBarButtonTitle: rightBarButtonTitle,
            backButtonIsHidden: backButtonIsHidden,
            didAppearAction: didAppearAction,
            didDismissAction: didDismissAction
        )
    }
}
