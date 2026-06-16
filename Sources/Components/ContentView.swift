import UIKit

@MainActor
public protocol ContentViewModel {
    associatedtype ViewType: ContentView where ViewType.Content == Self
    
    var verticalPadding: VerticalPadding? { get }
    var horizontalPadding: HorizontalPadding? { get }
    var accessibilityIdentifier: String? { get }
    var accessibilityTraits: UIAccessibilityTraits? { get }
    
    func createUIView() -> UIView
}

extension ContentViewModel {
    public func createUIView() -> UIView {
        let view = ViewType(viewModel: self)
        Self.enableAccessibilityInteraction(in: view)
        return view
    }
    
    static func enableAccessibilityInteraction(in view: UIView) {
        if view.isAccessibilityElement {
            view.accessibilityRespondsToUserInteraction = true
            return
        }
        for subview in view.subviews {
            enableAccessibilityInteraction(in: subview)
        }
    }
}

extension ContentViewModel where Self: ControlViewModel {
    public func createUIView() -> UIView {
        let view = ViewType(viewModel: self)
        Self.enableAccessibilityInteraction(in: view)
        if let control = view as? UIControl,
           let enableState = self.enableState {
            control.isEnabled = enableState.isEnabled
            enableState.onChange = { [weak control] in control?.isEnabled = $0 }
        }
        return view
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
