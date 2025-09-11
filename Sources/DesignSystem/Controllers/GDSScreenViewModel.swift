/// Protocol for the view model required to initilise ``GDSLeftAlignedScreen``
@MainActor
public protocol GDSScreenViewModel {
    var body: [any ContentViewModel] { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

public struct GDSCentreAlignedScreenViewModel: GDSScreenViewModel {
    public let body: [any ContentViewModel]
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
    }
}

public struct GDSLeftAlignedScreenViewModel: GDSScreenViewModel {
    public let body: [any ContentViewModel]
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
    }
}
