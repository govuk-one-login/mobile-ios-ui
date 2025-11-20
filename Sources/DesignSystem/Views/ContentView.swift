import UIKit

@MainActor
public protocol ContentViewModel {
    var verticalPadding: VerticalPadding? { get }
    var horizontalPadding: HorizontalPadding? { get }
    
    func createUIView() -> UIView
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
