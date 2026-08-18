import DesignSystem
import UIKit

// MARK: - Demo List Controller

/// Lists each NavigationBarButton usage variation for the demo.
final class NavigationBarButtonDemoViewController: UITableViewController {

    private enum Example: Int, CaseIterable {
        case legacy
        case singleButton
        case multipleButtons
        case menuButton

        var title: String {
            switch self {
            case .legacy: return "Legacy rightBarButtonTitle"
            case .singleButton: return "Single Button (new API)"
            case .multipleButtons: return "Multiple Buttons (new API)"
            case .menuButton: return "Menu with Items"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NavigationBarButton"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        Example.allCases.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Example.allCases[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let example = Example.allCases[indexPath.row]

        let screen: GDSScreen
        switch example {
        case .legacy:
            let legacyScreen = GDSScreen(viewModel: LegacyBarButtonViewModel())
            let modalNav = UINavigationController(rootViewController: legacyScreen)
            present(modalNav, animated: true)
            return
        case .singleButton:
            screen = GDSScreen(viewModel: SingleBarButtonViewModel())
        case .multipleButtons:
            let viewModel = MultipleBarButtonsViewModel(closeAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            screen = GDSScreen(viewModel: viewModel)
        case .menuButton:
            screen = GDSScreen(viewModel: MenuBarButtonViewModel())
        }

        navigationController?.pushViewController(screen, animated: true)
    }
}

// MARK: - 1. Legacy Usage
// Uses the original `rightBarButtonTitle` property to create a dismiss-style button.

private struct LegacyBarButtonViewModel: GDSScreenViewModel, BaseViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel] = [
        GDSTextViewModel(
            title: "Legacy Usage",
            titleFont: DesignSystem.Font.Base.title1Bold,
            alignment: .center,
            accessibilityTraits: .header
        ),
        GDSTextViewModel(
            title: """
            This screen uses the original `rightBarButtonTitle` property. \
            It creates a bar button with .plain style that dismisses the screen.
            """,
            titleFont: DesignSystem.Font.Base.body,
            alignment: .left
        )
    ]
    let movableFooter: [any ContentViewModel] = []
    let footer: [any ContentViewModel] = []

    // Legacy API
    let rightBarButtonTitle: GDSLocalisedString? = "Done"
    let backButtonTitle: GDSLocalisedString? = "Back"
    let backButtonIsHidden: Bool = false
    let didAppear: DesignSystem.Action? = nil
    let didDismiss: DesignSystem.Action? = .action({ print("Legacy: didDismiss called") })
}

// MARK: - 2. Single Button (new API)
// Uses `rightBarButtons` with a single `.button(...)` configuration.

private struct SingleBarButtonViewModel: GDSScreenViewModel, BaseViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel] = [
        GDSTextViewModel(
            title: "Single Button (New API)",
            titleFont: DesignSystem.Font.Base.title1Bold,
            alignment: .center,
            accessibilityTraits: .header
        ),
        GDSTextViewModel(
            title: """
            This screen uses `rightBarButtons` with a single button. \
            Tap the "Save" button in the navigation bar to trigger the action.
            """,
            titleFont: DesignSystem.Font.Base.body,
            alignment: .left
        )
    ]
    let movableFooter: [any ContentViewModel] = []
    let footer: [any ContentViewModel] = []

    // New API — single right bar button
    let rightBarButtonTitle: GDSLocalisedString? = nil
    let backButtonTitle: GDSLocalisedString? = "Back"
    let backButtonIsHidden: Bool = false
    let didAppear: DesignSystem.Action? = nil
    let didDismiss: DesignSystem.Action? = nil

    var rightBarButtons: [DesignSystem.NavigationBarButton]? {
        [
            .button(
                title: "Save",
                accessibilityIdentifier: "save-button",
                action: { print("Single button: Save tapped") }
            )
        ]
    }
}

// MARK: - 3. Multiple Buttons (new API)
// Uses `leftBarButtons` and `rightBarButtons` with multiple items.

private struct MultipleBarButtonsViewModel: GDSScreenViewModel, BaseViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel] = [
        GDSTextViewModel(
            title: "Multiple Buttons (New API)",
            titleFont: DesignSystem.Font.Base.title1Bold,
            alignment: .center,
            accessibilityTraits: .header
        ),
        GDSTextViewModel(
            title: """
            This screen demonstrates multiple bar buttons on both sides. \
            Left: a close button (image). Right: "Edit" and "Share" buttons.
            """,
            titleFont: DesignSystem.Font.Base.body,
            alignment: .left
        )
    ]
    let movableFooter: [any ContentViewModel] = []
    let footer: [any ContentViewModel] = []

    let rightBarButtonTitle: GDSLocalisedString? = nil
    let backButtonTitle: GDSLocalisedString? = "Back"
    let backButtonIsHidden: Bool = true
    let didAppear: DesignSystem.Action? = nil
    let didDismiss: DesignSystem.Action? = nil

    let closeAction: @MainActor () -> Void

    var leftBarButtons: [DesignSystem.NavigationBarButton]? {
        [
            .button(
                image: UIImage(systemName: "xmark"),
                accessibilityIdentifier: "close-button",
                action: closeAction
            )
        ]
    }

    var rightBarButtons: [DesignSystem.NavigationBarButton]? {
        [
            .button(
                title: "Edit",
                accessibilityIdentifier: "edit-button",
                action: { print("Multiple buttons: Edit tapped") }
            ),
            .button(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up"),
                accessibilityIdentifier: "share-button",
                action: { print("Multiple buttons: Share tapped") }
            )
        ]
    }
}

// MARK: - 4. Menu with Items
// Uses `.menu(...)` to present a contextual menu with NavigationBarMenuItem helpers.

private struct MenuBarButtonViewModel: GDSScreenViewModel, BaseViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel] = [
        GDSTextViewModel(
            title: "Menu with Items",
            titleFont: DesignSystem.Font.Base.title1Bold,
            alignment: .center,
            accessibilityTraits: .header
        ),
        GDSTextViewModel(
            title: """
            This screen uses a `.menu(...)` bar button. \
            Tap the ellipsis icon to see menu items built with `NavigationBarMenuItem`.
            """,
            titleFont: DesignSystem.Font.Base.body,
            alignment: .left
        )
    ]
    let movableFooter: [any ContentViewModel] = []
    let footer: [any ContentViewModel] = []

    let rightBarButtonTitle: GDSLocalisedString? = nil
    let backButtonTitle: GDSLocalisedString? = "Back"
    let backButtonIsHidden: Bool = false
    let didAppear: DesignSystem.Action? = nil
    let didDismiss: DesignSystem.Action? = nil

    var rightBarButtons: [DesignSystem.NavigationBarButton]? {
        [
            .menu(
                image: UIImage(systemName: "ellipsis.circle"),
                accessibilityIdentifier: "menu-button",
                menuProvider: { completion in
                    let items: [DesignSystem.NavigationBarMenuItem] = [
                        .init(
                            title: "Share",
                            image: UIImage(systemName: "square.and.arrow.up"),
                            action: { print("Menu: Share tapped") }
                        ),
                        .init(
                            title: "Copy Link",
                            image: UIImage(systemName: "link"),
                            action: { print("Menu: Copy Link tapped") }
                        ),
                        .init(
                            title: "Delete",
                            image: UIImage(systemName: "trash"),
                            isDestructive: true,
                            action: { print("Menu: Delete tapped") }
                        )
                    ]
                    completion(items.map { $0.toUIAction() })
                }
            )
        ]
    }
}
