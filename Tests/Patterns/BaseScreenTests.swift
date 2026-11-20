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
    
    // MARK: - Back button title applied to the previous screen
    //
    // These use `BackButtonStyleScreen` to force `usesTitledBackButton`, so both the
    // pre-iOS 26 (titled) and iOS 26+ (text-less) behaviours are exercised whatever
    // OS version the tests run on.
    
    @Test(arguments: [
        (OperatingSystemVersion(majorVersion: 17, minorVersion: 0, patchVersion: 0), true),
        (OperatingSystemVersion(majorVersion: 18, minorVersion: 6, patchVersion: 0), true),
        (OperatingSystemVersion(majorVersion: 25, minorVersion: 9, patchVersion: 9), true),
        (OperatingSystemVersion(majorVersion: 26, minorVersion: 0, patchVersion: 0), false),
        (OperatingSystemVersion(majorVersion: 27, minorVersion: 2, patchVersion: 0), false)
    ])
    func usesTitledBackButtonDependsOnOSVersion(version: OperatingSystemVersion, expected: Bool) {
        #expect(BaseScreen.usesTitledBackButton(for: version) == expected)
    }
    
    @Test
    func usesTitledBackButtonUsesCurrentOSVersion() {
        let sut = BaseScreen(
            viewModel: TestBaseViewModel(didAppear: nil, didDismiss: nil),
            bundle: .module
        )
        
        let expected = BaseScreen.usesTitledBackButton(
            for: ProcessInfo.processInfo.operatingSystemVersion
        )
        #expect(sut.usesTitledBackButton == expected)
    }
    
    @Test
    func backButtonTitleIsAppliedToPreviousScreen() {
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func backButtonTitleIsNotAppliedToPreviousScreenWithoutTitledBackButton() {
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: false)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == nil)
    }
    
    @Test
    func backButtonTitleIsNotAppliedToPreviousScreenWhenNil() {
        let previous = UIViewController()
        previous.navigationItem.backButtonTitle = "existing"
        var viewModel = TestBaseViewModel(didAppear: nil, didDismiss: nil)
        viewModel.backButtonTitle = nil
        let sut = BackButtonStyleScreen(viewModel: viewModel, usesTitledBackButton: true)
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
        let sut = BackButtonStyleScreen(viewModel: viewModel, usesTitledBackButton: true)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "existing")
    }
    
    @Test
    func backButtonTitleOverwritesExistingTitleOnPreviousScreen() {
        let previous = UIViewController()
        previous.navigationItem.backButtonTitle = "existing"
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let navigationController = UINavigationController(rootViewController: previous)
        
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func backButtonTitleIsAppliedToPreviousScreenWhenSetViaSetViewControllers() {
        let first = UIViewController()
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let navigationController = UINavigationController()
        
        navigationController.setViewControllers([first, previous, sut], animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "back button")
        #expect(first.navigationItem.backButtonTitle == nil)
    }
    
    @Test
    func backButtonTitleIsNotAppliedWhenScreenIsRoot() {
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        
        let navigationController = UINavigationController(rootViewController: sut)
        
        #expect(navigationController.viewControllers == [sut])
        #expect(sut.navigationItem.backButtonTitle == nil)
    }
    
    @Test
    func backButtonTitleIsReappliedAfterPopAndRepush() {
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let navigationController = UINavigationController(rootViewController: previous)
        navigationController.pushViewController(sut, animated: false)
        
        navigationController.popViewController(animated: false)
        previous.navigationItem.backButtonTitle = "changed"
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func backButtonTitleIsNotReappliedAfterPopAndRepushWithoutTitledBackButton() {
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: false)
        let navigationController = UINavigationController(rootViewController: previous)
        navigationController.pushViewController(sut, animated: false)
        
        navigationController.popViewController(animated: false)
        previous.navigationItem.backButtonTitle = "changed"
        navigationController.pushViewController(sut, animated: false)
        
        #expect(previous.navigationItem.backButtonTitle == "changed")
    }
    
    @Test
    func backButtonTitleIsAppliedToLastScreenWhenNotYetInStack() {
        let previous = UIViewController()
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let navigationController = UINavigationController(rootViewController: previous)
        
        // Called directly, before `sut` is in `viewControllers`, to cover the
        // case where `willMove(toParent:)` runs ahead of the stack being updated.
        sut.willMove(toParent: navigationController)
        
        #expect(navigationController.viewControllers == [previous])
        #expect(previous.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func backButtonTitleIsNotAppliedWhenParentIsNotNavigationController() {
        let previous = UIViewController()
        previous.navigationItem.backButtonTitle = "existing"
        let sut = BackButtonStyleScreen(usesTitledBackButton: true)
        let parent = UIViewController()
        
        sut.willMove(toParent: parent)
        sut.willMove(toParent: nil)
        
        #expect(previous.navigationItem.backButtonTitle == "existing")
        #expect(parent.navigationItem.backButtonTitle == nil)
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

/// Forces `usesTitledBackButton` so tests don't depend on the OS version they run on.
private final class BackButtonStyleScreen: BaseScreen {
    private let forcedUsesTitledBackButton: Bool
    
    override var usesTitledBackButton: Bool {
        forcedUsesTitledBackButton
    }
    
    init(
        viewModel: BaseViewModel = TestBaseViewModel(didAppear: nil, didDismiss: nil),
        usesTitledBackButton: Bool
    ) {
        self.forcedUsesTitledBackButton = usesTitledBackButton
        super.init(viewModel: viewModel, bundle: .module)
    }
}
