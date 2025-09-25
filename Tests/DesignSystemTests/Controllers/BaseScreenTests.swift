@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct BaseScreenTests {
    @Test
    func rightBarButtonContents() throws {
        let viewModel = TestBaseViewModel(didAppear: .action({ }), didDismiss: .action({ }))
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        let rightBarButton: UIBarButtonItem = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightBarButton.title == "right bar button")
    }
    
    @Test
    func backButtonContents() throws {
        let viewModel = TestBaseViewModel(didAppear: .action({ }), didDismiss: .action({ }))
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        #expect(sut.navigationItem.backButtonTitle == "back button")
    }
    
    @Test
    func rightBarButtonSetsAccessbilityIDOnViewLoad() {
        let viewModel = TestBaseViewModel(didAppear: .action({ }), didDismiss: .action({ }))
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        #expect(sut.navigationItem.rightBarButtonItem?.accessibilityIdentifier == nil)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        #expect(sut.navigationItem.rightBarButtonItem?.accessibilityIdentifier == "right-bar-button")
    }
    
    @Test
    func didAppear() {
        var didAppear = false
        
        let viewModel = TestBaseViewModel(didAppear: .action({ didAppear = true }), didDismiss: .action({ }))
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
                do {
                    try await Task.sleep(seconds: 1)
                    didAppear = true
                } catch {
                    return
                }
            }),
            didDismiss: .action({ })
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
        #expect(!didAppear)
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        await sut.appearAsyncTask?.value
        #expect(didAppear)
    }
    
    @Test
    func didDismiss() {
        var didDismiss = false
        
        let viewModel = TestBaseViewModel(didAppear: .action({ }), didDismiss: .action({ didDismiss = true }))
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)
        
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
                do {
                    try await Task.sleep(seconds: 1)
                    didDismiss = true
                } catch {
                    return
                }
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
    
    let didAppear: ButtonAction?
    let didDismiss: ButtonAction?
}
