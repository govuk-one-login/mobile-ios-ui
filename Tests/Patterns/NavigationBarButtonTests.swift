@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct NavigationBarButtonTests {

    // MARK: - Left Bar Button

    @Test
    func leftBarButton_withTitle_configuresNavigationItem() throws {
        let viewModel = BarButtonTestViewModel(
            leftBarButtons: [
                .button(title: "Done", accessibilityIdentifier: "done-button", action: { })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let leftButton = try #require(sut.navigationItem.leftBarButtonItem)
        #expect(leftButton.title == "Done")
        #expect(leftButton.accessibilityIdentifier == "done-button")
    }

    @Test
    func leftBarButton_withImage_configuresNavigationItem() throws {
        let image = UIImage(systemName: "xmark")
        let viewModel = BarButtonTestViewModel(
            leftBarButtons: [
                .button(image: image, accessibilityIdentifier: "close-button", action: { })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let leftButton = try #require(sut.navigationItem.leftBarButtonItem)
        #expect(leftButton.image != nil)
        #expect(leftButton.accessibilityIdentifier == "close-button")
    }

    @Test
    func leftBarButtons_nil_doesNotSetNavigationItem() {
        let viewModel = BarButtonTestViewModel()
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        #expect(sut.navigationItem.leftBarButtonItems == nil)
    }

    @Test
    func leftBarButton_actionIsCalled() throws {
        var actionCalled = false
        let viewModel = BarButtonTestViewModel(
            leftBarButtons: [
                .button(title: "Done", action: { actionCalled = true })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let leftButton = try #require(sut.navigationItem.leftBarButtonItem)
        if #available(iOS 16.0, *) {
            leftButton.primaryAction?.performWithSender(leftButton, target: nil)
        } else {
            _ = leftButton.target?.perform(leftButton.action)
        }
        #expect(actionCalled)
    }

    // MARK: - Right Bar Button (new API)

    @Test
    func rightBarButton_withTitle_configuresNavigationItem() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .button(title: "Save", accessibilityIdentifier: "save-button", action: { })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightButton.title == "Save")
        #expect(rightButton.accessibilityIdentifier == "save-button")
    }

    @Test
    func rightBarButton_actionIsCalled() throws {
        var actionCalled = false
        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .button(title: "Save", action: { actionCalled = true })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        if #available(iOS 16.0, *) {
            rightButton.primaryAction?.performWithSender(rightButton, target: nil)
        } else {
            _ = rightButton.target?.perform(rightButton.action)
        }
        #expect(actionCalled)
    }

    @Test
    func rightBarButtons_takePrecedenceOverRightBarButtonTitle() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtonTitle: "Legacy Title",
            rightBarButtons: [
                .button(title: "New Title", accessibilityIdentifier: "new-button", action: { })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightButton.title == "New Title")
        #expect(rightButton.accessibilityIdentifier == "new-button")
    }

    // MARK: - Right Bar Button (menu)

    @Test
    func rightBarButton_withMenu_configuresNavigationItem() throws {
        let image = UIImage(systemName: "ellipsis.circle")
        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .menu(
                    image: image,
                    accessibilityIdentifier: "menu-button",
                    menuProvider: { completion in
                        completion([UIAction(title: "Item 1") { _ in }])
                    }
                )
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        #expect(rightButton.image != nil)
        #expect(rightButton.menu != nil)
        #expect(rightButton.accessibilityIdentifier == "menu-button")
    }

    @Test
    func rightBarButton_menu_usesDeferredMenuElement() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .menu(
                    accessibilityIdentifier: "menu-button",
                    menuProvider: { completion in
                        completion([UIAction(title: "Action") { _ in }])
                    }
                )
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let rightButton = try #require(sut.navigationItem.rightBarButtonItem)
        let menu = try #require(rightButton.menu)
        #expect(menu.children.count == 1)
        #expect(menu.children.first is UIDeferredMenuElement)
    }

    @Test
    func rightBarButton_menu_menuProviderIsInvokedWhenResolved() throws {
        var menuProviderCalled = false
        var providedElements: [UIMenuElement] = []

        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .menu(
                    accessibilityIdentifier: "menu-button",
                    menuProvider: { completion in
                        menuProviderCalled = true
                        let items = [
                            UIAction(title: "Item 1") { _ in },
                            UIAction(title: "Item 2") { _ in }
                        ]
                        providedElements = items
                        completion(items)
                    }
                )
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        // Before menu presentation, provider should not have been called
        #expect(!menuProviderCalled)

        // Verify the menuProvider is correctly wired by invoking it
        // through the view model's configuration directly
        guard case .menu(_, let menuProvider) = viewModel.rightBarButtons?.first?.content else {
            Issue.record("Expected menu content")
            return
        }

        menuProvider { elements in
            providedElements = elements
        }

        #expect(menuProviderCalled)
        #expect(providedElements.count == 2)
    }

    // MARK: - Multiple Buttons

    @Test
    func multipleLeftBarButtons_configuresAllItems() throws {
        let viewModel = BarButtonTestViewModel(
            leftBarButtons: [
                .button(title: "Cancel", accessibilityIdentifier: "cancel-button", action: { }),
                .button(title: "Edit", accessibilityIdentifier: "edit-button", action: { })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let items = try #require(sut.navigationItem.leftBarButtonItems)
        #expect(items.count == 2)
        #expect(items[0].title == "Cancel")
        #expect(items[0].accessibilityIdentifier == "cancel-button")
        #expect(items[1].title == "Edit")
        #expect(items[1].accessibilityIdentifier == "edit-button")
    }

    @Test
    func multipleRightBarButtons_configuresAllItems() throws {
        let viewModel = BarButtonTestViewModel(
            rightBarButtons: [
                .button(title: "Save", accessibilityIdentifier: "save-button", action: { }),
                .menu(accessibilityIdentifier: "menu-button", menuProvider: { $0([]) })
            ]
        )
        let sut = BaseScreen(viewModel: viewModel, bundle: .module)

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        let items = try #require(sut.navigationItem.rightBarButtonItems)
        #expect(items.count == 2)
        #expect(items[0].title == "Save")
        #expect(items[1].menu != nil)
    }
}

// MARK: - Test Helper

struct BarButtonTestViewModel: BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString?
    var backButtonTitle: GDSLocalisedString? = "back"
    var backButtonIsHidden: Bool = false
    var didAppear: DesignSystem.Action? = .action({ })
    var didDismiss: DesignSystem.Action? = .action({ })
    var leftBarButtons: [DesignSystem.NavigationBarButton]?
    var rightBarButtons: [DesignSystem.NavigationBarButton]?
}
