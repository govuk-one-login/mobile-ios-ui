import UIKit

@MainActor
public protocol ContentViewModel {
    associatedtype ViewType: ContentView where ViewType.Content == Self
    
    var verticalPadding: VerticalPadding? { get }
    var horizontalPadding: HorizontalPadding? { get }
}

extension ContentViewModel {
    public func createUIView() -> UIView {
        ViewType(viewModel: self)
    }
}

public protocol ContentView: UIView {
    associatedtype Content: ContentViewModel
    
    init(viewModel: Content)
}

@resultBuilder
public struct ContentItemBuilder {
    public static func buildBlock(_ components: [any ContentViewModel]...) -> [any ContentViewModel] {
        components.flatMap { $0 }
    }

    /// Add support for both single and collections of constraints.
    public static func buildExpression(_ expression: any ContentViewModel) -> [any ContentViewModel] {
        [expression]
    }

    public static func buildExpression(_ expression: [any ContentViewModel]) -> [any ContentViewModel] {
        expression
    }
}
