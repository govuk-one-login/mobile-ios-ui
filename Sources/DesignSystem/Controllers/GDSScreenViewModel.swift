import UIKit

/// Protocol for the view model required to initilise ``GDSLeftAlignedScreen``
@MainActor
public protocol GDSScreenViewModel {
    var body: [any ContentViewModel] { get }
    var verticalAlignment: VerticalScreenAlignment { get }
    var horizontalAlignment: UIStackView.Alignment { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

extension GDSScreenViewModel {
    public var verticalAlignment: VerticalScreenAlignment { .top }
    public var horizontalAlignment: UIStackView.Alignment { .fill }
}

public enum VerticalScreenAlignment {
    case top, center
}

public struct GDSDemoScreenViewModel: GDSScreenViewModel {
    public let body: [any ContentViewModel]
    public let verticalAlignment: VerticalScreenAlignment
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        body: [any ContentViewModel],
        verticalAlignment: VerticalScreenAlignment,
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.body = body
        self.verticalAlignment = verticalAlignment
        self.movableFooter = movableFooter
        self.footer = footer
    }
}
