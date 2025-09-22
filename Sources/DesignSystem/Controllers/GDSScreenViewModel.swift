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
        footer: [any ContentViewModel]
    )
}

extension GDSCentreAlignedViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: screenStyle,
            body: body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
    
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: .topCentred,
            body: body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
}

public protocol GDSLeftAlignedViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    )
}

extension GDSLeftAlignedViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: screenStyle,
            body: body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
    
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: .topLeadingAligned,
            body: body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
}

public protocol GDSErrorScreenViewModel: BaseViewModel, GDSScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    )
}

extension GDSErrorScreenViewModel {
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: screenStyle,
            body: body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
    
    public init(
        icon: GDSImageViewModel,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self = Self(
            screenStyle: .error,
            body: [icon] + body,
            movableFooter: movableFooter,
            footer: footer
        )
    }
}
