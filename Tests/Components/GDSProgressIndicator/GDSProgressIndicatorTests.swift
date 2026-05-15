@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSProgressIndicatorTests {
    let viewModel = GDSProgressIndicatorViewModel()
    
    @Test("Test configuration used for icon view")
    func setsCorrectIconViewConfiguration() {
        let view = GDSProgressIndicator(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIActivityIndicatorView
        
        #expect(iconView?.color == viewModel.progressIndicatorColor)
        #expect(iconView?.style == .large)
    }
    
    @Test("Test configuration used for title view")
    func setsCorrectTitleViewConfiguration() {
        let view = GDSProgressIndicator(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Loading")
    }
    
    @Test("Test configuration used for stack view")
    func setsCorrectStackViewConfiguration() {
        let view = GDSProgressIndicator(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        
        #expect(stackView?.arrangedSubviews.count == 2)
        #expect(stackView?.axis == .vertical)
        #expect(stackView?.alignment == .center)
        #expect(stackView?.distribution == .equalSpacing)
        #expect(stackView?.spacing == CGFloat(DesignSystem.Spacing.default))
        
        #expect(stackView?.isAccessibilityElement == true)
        #expect(stackView?.shouldGroupAccessibilityChildren == true)
        #expect(stackView?.accessibilityLabel == "Loading")
        
        #expect(stackView?.accessibilityTraits.contains(.none) == true)
        #expect(stackView?.accessibilityIdentifier == "progress-indicator-stack-view")
    }
    
    @Test("Test configuration used to change the title after 5 seconds")
    func titleViewAfterFiveSeconds() async throws {
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel)
        let window = UIWindow()
        window.rootViewController = UIViewController()
        window.rootViewController?.view.addSubview(progressIndicator)
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        
        try await Task.sleep(seconds: 5)
        
        let stackView = progressIndicator.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Still loading")
        #expect(stackView?.accessibilityLabel == "Still loading")
        
    }
    
    @Test("Test configuration used to change the title after 10 seconds")
    func titleViewAfterTenSeconds() async throws {
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel)
        let window = UIWindow()
        window.rootViewController = UIViewController()
        window.rootViewController?.view.addSubview(progressIndicator)
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        
        try await Task.sleep(seconds: 10)
        
        let stackView = progressIndicator.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Still loading, keep waiting")
        #expect(stackView?.accessibilityLabel == "Still loading, keep waiting")
    }
}
