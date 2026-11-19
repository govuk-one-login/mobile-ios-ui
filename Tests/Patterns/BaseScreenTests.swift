@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct BaseScreenTests {
    @Test
    func rightBarButtonContents() throws {
        let viewModel = TestBaseViewModel(
            didAppear: .action({ }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(
            viewModel: viewModel,
            bundle: .module
        )
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        let rightBarButton: UIBarButtonItem = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightBarButton.title == "right bar button")
    }
    
    @Test
    func backButtonTitleIsAppliedToPreviousScreen() {
        let previous = UIViewController()
        let sut = BaseScreen(
            viewModel: TestBaseViewModel(didAppear: nil, didDismiss: nil),
            bundle: .module
        )
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        if #available(iOS 26.0, *) {
            #expect(previous.navigationItem.backButtonTitle == nil)
        } else {
            #expect(previous.navigationItem.backButtonTitle == "back button")
        }
    }
    
    @Test
    func backButtonTitleIsNotAppliedToPreviousScreenWhenNil() {
        let previous = UIViewController()
        previous.navigationItem.backButtonTitle = "existing"
        var viewModel = TestBaseViewModel(didAppear: nil, didDismiss: nil)
        viewModel.backButtonTitle = nil
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "existing")
    }
    
    @Test
    func backButtonTitleIsNotAppliedToPreviousScreenWhenBackButtonHidden() {
        let previous = UIViewController()
        previous.navigationItem.backButtonTitle = "existing"
        var viewModel = TestBaseViewModel(didAppear: nil, didDismiss: nil)
        viewModel.backButtonIsHidden = true
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "existing")
    }
    
    @Test
    func backButtonTitleIsAppliedToPreviousScreenWhenSetViaSetViewControllers() {
        let first = UIViewController()
        let previous = UIViewController()
        let sut = BaseScreen(
            viewModel: TestBaseViewModel(didAppear: nil, didDismiss: nil),
            bundle: .module
        )
        let navigationController = UINavigationController()
        
        navigationController.setViewControllers([first, previous, sut], animated: false)
        
        if #available(iOS 26.0, *) {
            #expect(previous.navigationItem.backButtonTitle == nil)
        } else {
            #expect(previous.navigationItem.backButtonTitle == "back button")
        }
        #expect(first.navigationItem.backButtonTitle == nil)
    }
    
    @Test
    func backButtonTitleDoesNotCrashWhenScreenIsRoot() {
        let sut = BaseScreen(
            viewModel: TestBaseViewModel(didAppear: nil, didDismiss: nil),
            bundle: .module
        )
        
        let navigationController = UINavigationController(rootViewController: sut)
        
        #expect(navigationController.viewControllers == [sut])
    }
    
    @Test
    func backButtonTitleIsReappliedAfterPopAndRepush() {
        let previous = UIViewController()
        let sut = BaseScreen(
            viewModel: TestBaseViewModel(didAppear: nil, didDismiss: nil),
            bundle: .module
        )
        let navigationController = UINavigationController(rootViewController: previous)
        navigationController.pushViewController(sut, animated: false)
        
        navigationController.popViewController(animated: false)
        previous.navigationItem.backButtonTitle = "changed"
        navigationController.pushViewController(sut, animated: false)
        
        if #available(iOS 26.0, *) {
            #expect(previous.navigationItem.backButtonTitle == "changed")
        } else {
            #expect(previous.navigationItem.backButtonTitle == "back button")
        }
    }
    
    @Test
    func backButtonContents() throws {
        let viewModel = TestBaseViewModel(
            didAppear: .action({ }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(
            viewModel: viewModel,
            bundle: .module
        )
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        #expect(sut.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func rightBarButtonSetsAccessbilityIDOnViewLoad() {
        let viewModel = TestBaseViewModel(
            didAppear: .action({ }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(
            viewModel: viewModel,
            bundle: .module
        )
        
        #expect(sut.navigationItem.rightBarButtonItem?.accessibilityIdentifier == nil)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        #expect(sut.navigationItem.rightBarButtonItem?.accessibilityIdentifier == "right-bar-button")
    }
    
    @Test
    func didAppear() {
        var didAppear = false
        
        let viewModel = TestBaseViewModel(
            didAppear: .action({ didAppear = true }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        #expect(!didAppear)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        #expect(didAppear)
    }
    
    @Test
    func asyncDidAppear() async {
        var didAppear = false
        
        let viewModel = TestBaseViewModel(
            didAppear: .asyncAction({
                try? await Task.sleep(seconds: 1)
                didAppear = true
            }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(
            viewModel: viewModel,
            bundle: .module
        )
        
        #expect(!didAppear)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        await sut.appearAsyncTask?.value
        #expect(didAppear)
    }
    
    @Test
    func didDismiss() {
        var didDismiss = false
        
        let viewModel = TestBaseViewModel(
            didAppear: .action({ }),
            didDismiss: .action({ didDismiss = true })
        )
        let sut = BaseScreen(
            viewModel: viewModel,
            bundle: .module
        )
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        #expect(!didDismiss)
        _ = sut.navigationItem.rightBarButtonItem?.target?.perform(sut.navigationItem.rightBarButtonItem?.action)
        #expect(didDismiss)
    }
    
    @Test
    func asyncDidDismiss() async {
        var didDismiss = false

        let viewModel = TestBaseViewModel(
            didAppear: .action({ }),
            didDismiss: .asyncAction({
                try? await Task.sleep(seconds: 1)
                didDismiss = true
            })
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        #expect(!didDismiss)
        _ = sut.navigationItem.rightBarButtonItem?.target?.perform(sut.navigationItem.rightBarButtonItem?.action)
        await sut.dismissAsyncTask?.value
        #expect(didDismiss)
    }
}

struct TestBaseViewModel: BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString? = "right bar button"
    var backButtonTitle: GDSLocalisedString? = "back button"
    var backButtonIsHidden: Bool = false
    
    let didAppear: DesignSystem.Action?
    let didDismiss: DesignSystem.Action?
}
