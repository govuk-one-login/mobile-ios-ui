import UIKit

@MainActor
public protocol GDSScreenViewModel {
    var screenStyle: GDSScreenStyle { get }
    var body: [any ContentViewModel] { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
    var backgroundColor: UIColor? { get }
    var footerBackgroundColor: UIColor? { get }
    var safeAreaEdgesToIgnore: NSDirectionalRectEdge { get }
}

extension GDSScreenViewModel {
    public var footerBackgroundColor: UIColor? { nil }
    public var backgroundColor: UIColor? { .systemBackground }
    
    public var safeAreaEdgesToIgnore: NSDirectionalRectEdge {
        footerBackgroundColor != nil ? .bottom : .none
    }
}
