import UIKit

/// Protocol for the view model required to initilise ``GDSLeftAlignedScreen``
@MainActor
public protocol GDSScreenViewModel {
    var screenStyle: GDSScreenStyle { get }
    var body: [any ContentViewModel] { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

public struct GDSDemoScreenViewModel: GDSScreenViewModel {
    public let screenStyle: GDSScreenStyle
    public let body: [any ContentViewModel]
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        screenStyle: GDSScreenStyle = .topCentred,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
    }
}
