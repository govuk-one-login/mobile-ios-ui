@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct NavigationBarButtonBackwardCompatTests {

    // MARK: - Legacy rightBarButtonTitle

    @Test
    func legacyRightBarButtonTitle_stillWorks() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Dismiss"
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightButton.title == "Dismiss")
        #expect(rightButton.accessibilityIdentifier == "right-bar-button")
    }

    @Test
    func legacyRightBarButtonTitle_hasDoneStyle() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Close"
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightButton.style == .plain)
    }

    @Test
    func legacyRightBarButtonTitle_triggersDismissAndDidDismiss() {
        var didDismiss = false
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Done",
            didDismiss: .action({ didDismiss = true })
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(!didDismiss)
        _ = sut.navigationItem.rightBarButtonItem?.target?.perform(
            sut.navigationItem.rightBarButtonItem?.action
        )
        #expect(didDismiss)
    }

    @Test
    func legacyViewModel_doesNotSetLeftBarButtons() {
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Close"
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItems == nil)
    }

    @Test
    func viewModelWithoutAnyBarButtonConfig_setsNothing() {
        let viewModel = LegacyViewModelWithNoButtons()
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItem == nil)
        #expect(sut.navigationItem.rightBarButtonItem == nil)
    }

    @Test
    func noBarButtons_doesNotSetAnyButtons() {
        let viewModel = BarButtonTestViewModel()
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItem == nil)
        #expect(sut.navigationItem.rightBarButtonItem == nil)
    }

    // MARK: - Empty Array vs Nil

    @Test
    func leftBarButtons_emptyArray_clearsExistingButtons() {
        let viewModel = BarButtonTestViewModel(leftBarButtons: [])
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Pre-existing")

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItems == [])
        #expect(sut.navigationItem.leftBarButtonItem == nil)
    }

    @Test
    func rightBarButtons_emptyArray_clearsExistingButtons() {
        let viewModel = BarButtonTestViewModel(rightBarButtons: [])
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pre-existing")

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.rightBarButtonItems == [])
        #expect(sut.navigationItem.rightBarButtonItem == nil)
    }

    @Test
    func leftBarButtons_nil_doesNotTouchExistingButtons() {
        let viewModel = BarButtonTestViewModel()
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        let existingButton = UIBarButtonItem(title: "Pre-existing")
        sut.navigationItem.leftBarButtonItem = existingButton

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItem === existingButton)
    }

    @Test
    func rightBarButtons_emptyArray_preventsLegacyFallback() {
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Dismiss",
            rightBarButtons: []
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.rightBarButtonItem == nil)
    }

    // MARK: - NavigationBarMenuItem

    @Test
    func menuItem_toUIAction_hasCorrectProperties() {
        let image = UIImage(systemName: "trash")
        var actionCalled = false
        let menuItem = DesignSystem.NavigationBarMenuItem(
            title: "Delete",
            image: image,
            isDestructive: true,
            action: { actionCalled = true }
        )

        let uiAction = menuItem.toUIAction()
        #expect(uiAction.title == "Delete")
        #expect(uiAction.image != nil)
        #expect(uiAction.attributes == .destructive)

        if #available(iOS 16.0, *) {
            uiAction.performWithSender(nil, target: nil)
            #expect(actionCalled)
        }
    }

    @Test
    func menuItem_nonDestructive_hasEmptyAttributes() {
        let menuItem = DesignSystem.NavigationBarMenuItem(
            title: "Share",
            action: { }
        )

        let uiAction = menuItem.toUIAction()
        #expect(uiAction.attributes == [])
    }
}

// MARK: - Test Helpers

/// Mimics a view model that only uses the original BaseViewModel properties
/// (no leftBarButtons, no rightBarButtons) — proves the protocol defaults work.
private struct LegacyViewModelWithNoButtons: BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString?
    var backButtonTitle: GDSLocalisedString? = "back"
    var backButtonIsHidden: Bool = false
    var didAppear: DesignSystem.Action? = .action({ })
    var didDismiss: DesignSystem.Action? = .action({ })
}
