import DesignSystem
@testable import DesignSystemDemo
import Testing
import UIKit

@MainActor
struct NavigationBarButtonDemoViewControllerTests {

    // MARK: - Table View Setup

    @Test
    func viewDidLoad_setsTitle() {
        let sut = NavigationBarButtonDemoViewController(style: .insetGrouped)
        sut.loadViewIfNeeded()

        #expect(sut.title == "NavigationBarButton")
    }

    @Test
    func tableView_hasFourRows() {
        let sut = NavigationBarButtonDemoViewController(style: .insetGrouped)
        sut.loadViewIfNeeded()

        #expect(sut.tableView.numberOfRows(inSection: 0) == 4)
    }

    @Test
    func tableView_cellTitles() {
        let sut = NavigationBarButtonDemoViewController(style: .insetGrouped)
        sut.loadViewIfNeeded()

        let expectedTitles = [
            "Legacy rightBarButtonTitle",
            "Single Button (new API)",
            "Multiple Buttons (new API)",
            "Menu with Items"
        ]

        for (index, expected) in expectedTitles.enumerated() {
            let cell = sut.tableView(
                sut.tableView,
                cellForRowAt: IndexPath(row: index, section: 0)
            )
            #expect(cell.textLabel?.text == expected)
            #expect(cell.accessoryType == .disclosureIndicator)
        }
    }

    // MARK: - Legacy Usage

    @Test
    func legacyExample_presentsScreenModally() throws {
        let (sut, nav) = makeNavigationController()

        // Modal presentation requires a window hierarchy
        let window = UIWindow()
        window.rootViewController = nav
        window.makeKeyAndVisible()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        let modalNav = try #require(sut.presentedViewController as? UINavigationController)
        let presentedScreen = try #require(modalNav.viewControllers.first as? GDSScreen)
        presentedScreen.beginAppearanceTransition(true, animated: false)
        presentedScreen.endAppearanceTransition()

        let rightButton = try #require(presentedScreen.navigationItem.rightBarButtonItem)
        #expect(rightButton.title == "Done")
        #expect(rightButton.style == .plain)
        #expect(rightButton.accessibilityIdentifier == "right-bar-button")

        window.resignKey()
        window.isHidden = true
    }

    // MARK: - Single Button (new API)

    @Test
    func singleButtonExample_pushesScreenWithSaveButton() throws {
        let (sut, nav) = makeNavigationController()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 1, section: 0))

        let pushedScreen = try #require(nav.viewControllers.last as? GDSScreen)
        pushedScreen.beginAppearanceTransition(true, animated: false)
        pushedScreen.endAppearanceTransition()

        let rightButton = try #require(pushedScreen.navigationItem.rightBarButtonItem)
        #expect(rightButton.title == "Save")
        #expect(rightButton.accessibilityIdentifier == "save-button")
    }

    // MARK: - Multiple Buttons (new API)

    @Test
    func multipleButtonsExample_pushesScreenWithLeftAndRightButtons() throws {
        let (sut, nav) = makeNavigationController()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 2, section: 0))

        let pushedScreen = try #require(nav.viewControllers.last as? GDSScreen)
        pushedScreen.beginAppearanceTransition(true, animated: false)
        pushedScreen.endAppearanceTransition()

        // Left bar button: close
        let leftButton = try #require(pushedScreen.navigationItem.leftBarButtonItem)
        #expect(leftButton.image != nil)
        #expect(leftButton.accessibilityIdentifier == "close-button")

        // Right bar buttons: Edit + Share
        let rightButtons = try #require(pushedScreen.navigationItem.rightBarButtonItems)
        #expect(rightButtons.count == 2)
        #expect(rightButtons[0].title == "Edit")
        #expect(rightButtons[0].accessibilityIdentifier == "edit-button")
        #expect(rightButtons[1].accessibilityIdentifier == "share-button")
        #expect(rightButtons[1].image != nil)
    }

    @Test
    func multipleButtonsExample_hidesBackButton() throws {
        let (sut, nav) = makeNavigationController()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 2, section: 0))

        let pushedScreen = try #require(nav.viewControllers.last as? GDSScreen)
        pushedScreen.beginAppearanceTransition(true, animated: false)
        pushedScreen.endAppearanceTransition()

        #expect(pushedScreen.navigationItem.hidesBackButton == true)
    }

    // MARK: - Menu with Items

    @Test
    func menuExample_pushesScreenWithMenuButton() throws {
        let (sut, nav) = makeNavigationController()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))

        let pushedScreen = try #require(nav.viewControllers.last as? GDSScreen)
        pushedScreen.beginAppearanceTransition(true, animated: false)
        pushedScreen.endAppearanceTransition()

        let rightButton = try #require(pushedScreen.navigationItem.rightBarButtonItem)
        #expect(rightButton.image != nil)
        #expect(rightButton.menu != nil)
        #expect(rightButton.accessibilityIdentifier == "menu-button")
    }

    @Test
    func menuExample_menuUsesDeferredElement() throws {
        let (sut, nav) = makeNavigationController()

        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 3, section: 0))

        let pushedScreen = try #require(nav.viewControllers.last as? GDSScreen)
        pushedScreen.beginAppearanceTransition(true, animated: false)
        pushedScreen.endAppearanceTransition()

        let rightButton = try #require(pushedScreen.navigationItem.rightBarButtonItem)
        let menu = try #require(rightButton.menu)
        #expect(menu.children.count == 1)
        #expect(menu.children.first is UIDeferredMenuElement)
    }

    // MARK: - Helpers

    private func makeNavigationController() -> (
        NavigationBarButtonDemoViewController,
        UINavigationController
    ) {
        let sut = NavigationBarButtonDemoViewController(style: .insetGrouped)
        let nav = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        return (sut, nav)
    }
}
