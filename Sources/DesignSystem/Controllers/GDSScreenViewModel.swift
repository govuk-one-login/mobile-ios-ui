import UIKit

/// Protocol for the view model required to initilise ``GDSLeftAlignedScreen``
@MainActor
public protocol GDSScreenViewModel {
    var body: [any ContentViewModel] { get }
    var screenStyle: GDSScreenStyle { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

public struct GDSScreenStyle {
    let verticalAlignment: VerticalScreenAlignment
    let horizontalAlignment: UIStackView.Alignment
    
    public init(
        verticalAlignment: VerticalScreenAlignment,
        horizontalAlignment: UIStackView.Alignment
    ) {
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
    }
}

extension GDSScreenStyle {
    public static var standardTop: Self {
        GDSScreenStyle(
            verticalAlignment: .top,
            horizontalAlignment: .fill
        )
    }
}

public enum VerticalScreenAlignment {
    case top, center
}

public struct GDSDemoScreenViewModel: GDSScreenViewModel {
    public let body: [any ContentViewModel]
    public let screenStyle: GDSScreenStyle
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        body: [any ContentViewModel],
        screenStyle: GDSScreenStyle = .standardTop,
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.body = body
        self.screenStyle = screenStyle
        self.movableFooter = movableFooter
        self.footer = footer
    }
}
