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
        
        #expect(iconView?.color == .secondaryLabel)
        #expect(iconView?.style == .large)
        #expect(iconView?.isAnimating == true)
        #expect(iconView?.isAccessibilityElement == false)
        
        let colorViewModel = GDSProgressIndicatorViewModel(progressIndicatorColor: DesignSystem.Color.Base.white)
        let colorView = GDSProgressIndicator(viewModel: colorViewModel)
        let colorStackView = colorView.subviews.first as? UIStackView
        let colorIconView = colorStackView?.arrangedSubviews.first as? UIActivityIndicatorView
        
        #expect(colorIconView?.color == DesignSystem.Color.Base.white)
    }
    
    @Test("Test configuration used for title view")
    func setsCorrectTitleViewConfiguration() {
        let view = GDSProgressIndicator(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Loading")
        #expect(titleView?.isAccessibilityElement == false)
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
        #expect(stackView?.accessibilityLabel == "Loading")
        
        #expect(stackView?.accessibilityTraits.contains(.none) == true)
        #expect(stackView?.accessibilityIdentifier == "progress-indicator-stack-view")
    }
    
    @Test("ProgressIndicator has custom accessibility identifier")
    func customAccessibilityIdentifier() {
        let vm = GDSProgressIndicatorViewModel(accessibilityIdentifier: "custom-progress")
        let view = GDSProgressIndicator(viewModel: vm)
        let stackView = view.subviews.first as? UIStackView
        #expect(stackView?.accessibilityIdentifier == "custom-progress")
    }
    
    @Test("ProgressIndicator has custom accessibility traits")
    func customAccessibilityTraits() {
        let vm = GDSProgressIndicatorViewModel(accessibilityTraits: .updatesFrequently)
        let view = GDSProgressIndicator(viewModel: vm)
        let stackView = view.subviews.first as? UIStackView
        #expect(stackView?.accessibilityTraits == .updatesFrequently)
    }
    
    @Test("Test configuration used to change the title after 5 seconds")
    func titleViewAfterFiveSeconds() {
        let scheduler = ManualScheduler()
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel, scheduler: scheduler.schedule)
        let window = show(progressIndicator)
        
        #expect(scheduler.delays == [5, 10])
        
        scheduler.run(delay: 5)
        
        let stackView = progressIndicator.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Still loading")
        #expect(stackView?.accessibilityLabel == "Still loading")
        withExtendedLifetime(window) {}
    }
    
    @Test("Test configuration used to change the title after 10 seconds")
    func titleViewAfterTenSeconds() {
        let scheduler = ManualScheduler()
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel, scheduler: scheduler.schedule)
        let window = show(progressIndicator)
        
        scheduler.run(delay: 5)
        scheduler.run(delay: 10)
        
        let stackView = progressIndicator.subviews.first as? UIStackView
        let titleView = stackView?.arrangedSubviews.last as? GDSTextView
        
        #expect(titleView?.text == "Still loading, keep waiting")
        #expect(stackView?.accessibilityLabel == "Still loading, keep waiting")
        withExtendedLifetime(window) {}
    }
    
    @Test("Title does not change before the delays have elapsed")
    func titleUnchangedBeforeDelays() {
        let scheduler = ManualScheduler()
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel, scheduler: scheduler.schedule)
        let window = show(progressIndicator)
        
        let titleView = (progressIndicator.subviews.first as? UIStackView)?.arrangedSubviews.last as? GDSTextView
        #expect(titleView?.text == viewModel.title.title.value)
        withExtendedLifetime(window) {}
    }
    
    @Test("Pending title changes are cancelled when removed from the window")
    func titleChangesCancelledWhenRemoved() {
        let scheduler = ManualScheduler()
        let progressIndicator = GDSProgressIndicator(viewModel: viewModel, scheduler: scheduler.schedule)
        let window = show(progressIndicator)
        
        progressIndicator.removeFromSuperview()
        scheduler.run(delay: 5)
        scheduler.run(delay: 10)
        
        let titleView = (progressIndicator.subviews.first as? UIStackView)?.arrangedSubviews.last as? GDSTextView
        #expect(titleView?.text == viewModel.title.title.value)
        withExtendedLifetime(window) {}
    }
    
    private func show(_ view: UIView) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = UIViewController()
        window.rootViewController?.view.addSubview(view)
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        return window
    }
}
