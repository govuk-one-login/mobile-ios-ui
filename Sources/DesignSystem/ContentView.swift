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
