/// Protocol for the view model required to initilise ``GDSLeftAlignedScreen``
@MainActor
public protocol GDSScreenViewModel {
    var title: GDSLocalisedString { get }
    var body: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}

public struct GDSCentreAlignedScreenViewModel: GDSScreenViewModel {
    public var title: GDSLocalisedString
    public var body: [any ContentViewModel]
    public var footer: [any ContentViewModel]
    
    public init(
        title: GDSLocalisedString,
        body: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.title = title
        self.body = body
        self.footer = footer
    }
}
