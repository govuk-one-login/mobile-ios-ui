import DesignSystem
import UIKit

// MARK: - iOS 26+ behaviour

/// From iOS 26 the back button is an icon-only glass chevron, so custom titles
/// are not shown. Returns `text` on earlier versions, or an icon-only note on 26+.
private func expectation(_ text: String) -> String {
    if #available(iOS 26, *) {
        return "On iOS 26+ the back button is icon-only (chevron), with no custom text."
    }
    return text
}

// MARK: - Demo List Controller

/// Demonstrates `BaseScreen`'s handling of `backButtonTitle` on iOS < 26.
///
/// UIKit sources a back button's title from the `navigationItem` of the screen
/// being returned *to*, so setting `backButtonTitle` on the pushed screen alone
/// had no effect. `BaseScreen` now also applies the pushed screen's title to the
/// previous screen in `willMove(toParent:)`.
///
/// This list is deliberately a plain `UITableViewController` (not a `BaseScreen`)
/// with a long title, so a wrongly sourced back button is easy to spot: before
/// the fix the pushed screen's back button showed this screen's title
/// ("Back Button Title") rather than the view model's title.
///
/// On iOS 26+ the back button is a text-less chevron, so the title is not
/// visible; run on an iOS 15–25 simulator to see the fix.
final class BackButtonTitleDemoViewController: UITableViewController {

    private enum Example: Int, CaseIterable {
        case customTitle
        case welshTitle
        case hiddenBackButton
        case noTitle
        case chain

        var title: String {
            switch self {
            case .customTitle: return "Custom title (\"Custom Back\")"
            case .welshTitle: return "Welsh title (\"Yn ôl\")"
            case .hiddenBackButton: return "Back button hidden"
            case .noTitle: return "No title (UIKit default)"
            case .chain: return "Chain of BaseScreens"
            }
        }

        var detail: String {
            switch self {
            case .customTitle:
                return expectation("Back button should read \"Custom Back\"")
            case .welshTitle:
                return expectation("Back button should read \"Yn ôl\"")
            case .hiddenBackButton:
                return "No back button; title not applied to this screen"
            case .noTitle:
                return "Back button falls back to this screen's title"
            case .chain:
                return expectation("Back to list, then \"Back to 1\", \"Back to 2\"…")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Back Button Title"
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
        titleForHeaderInSection section: Int
    ) -> String? {
        "Origin screen is a plain UIViewController (not a BaseScreen)"
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let example = Example.allCases[indexPath.row]
        var content = UIListContentConfiguration.subtitleCell()
        content.text = example.title
        content.secondaryText = example.detail
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let screen: UIViewController
        switch Example.allCases[indexPath.row] {
        case .customTitle:
            screen = makeScreen(
                heading: "Custom title",
                explanation: expectation("The back button on this screen should read \"Custom Back\"."),
                backButtonTitle: "Custom Back"
            )
        case .welshTitle:
            screen = makeScreen(
                heading: "Welsh title",
                explanation: expectation("""
                The back button should read "Yn ôl" from the app's own string, \
                rather than a UIKit-provided title that has no Welsh translation.
                """),
                backButtonTitle: "Yn ôl"
            )
        case .hiddenBackButton:
            screen = makeScreen(
                heading: "Back button hidden",
                explanation: """
                `backButtonIsHidden` is true, so no back button is shown and \
                the title is not applied to the previous screen. Use the \"Go back\" button to leave.
                """,
                backButtonTitle: "Should not appear",
                backButtonIsHidden: true
            )
        case .noTitle:
            screen = makeScreen(
                heading: "No title",
                explanation: """
                The view model has no `backButtonTitle`, so nothing is applied and \
                UIKit's default (the previous screen's title) is used.
                """,
                backButtonTitle: nil
            )
        case .chain:
            screen = makeChainScreen(depth: 1)
        }

        navigationController?.pushViewController(screen, animated: true)
    }

    // MARK: - Screen factories

    private func makeScreen(
        heading: String,
        explanation: String,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool = false
    ) -> GDSScreen {
        // With the system back button hidden, provide an alternative way out.
        var goBack: (@MainActor () -> Void)?
        if backButtonIsHidden {
            goBack = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        return GDSScreen(
            viewModel: BackButtonDemoViewModel(
                heading: heading,
                explanation: explanation,
                backButtonTitle: backButtonTitle,
                backButtonIsHidden: backButtonIsHidden,
                footerButtonTitle: backButtonIsHidden ? "Go back" : nil,
                footerButtonAction: goBack
            )
        )
    }

    /// Each screen's back title names its destination: screen 1 goes back to the
    /// list, screen N goes back to screen N-1. With the fix, that title comes from
    /// the pushed screen's own view model rather than the previous screen's.
    private func makeChainScreen(depth: Int) -> GDSScreen {
        let destination = depth == 1 ? "list" : "\(depth - 1)"
        let viewModel = BackButtonDemoViewModel(
            heading: "Chain screen \(depth)",
            explanation: expectation("""
            This screen's back button should read "Back to \(destination)". \
            Push another screen and its back button should read "Back to \(depth)".
            """),
            backButtonTitle: GDSLocalisedString(stringKey: "Back to \(destination)"),
            backButtonIsHidden: false,
            footerButtonTitle: "Push screen \(depth + 1)",
            footerButtonAction: { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(
                    self.makeChainScreen(depth: depth + 1),
                    animated: true
                )
            }
        )
        return GDSScreen(viewModel: viewModel)
    }
}

// MARK: - View Model

private struct BackButtonDemoViewModel: GDSScreenViewModel, BaseViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel] = []
    let footer: [any ContentViewModel]

    let rightBarButtonTitle: GDSLocalisedString? = nil
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    let didAppear: DesignSystem.Action? = nil
    let didDismiss: DesignSystem.Action? = nil

    init(
        heading: String,
        explanation: String,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        footerButtonTitle: String? = nil,
        footerButtonAction: (@MainActor () -> Void)? = nil
    ) {
        self.backButtonTitle = backButtonTitle
        self.backButtonIsHidden = backButtonIsHidden
        self.body = [
            GDSTextViewModel(
                title: GDSLocalisedString(stringKey: heading),
                titleFont: DesignSystem.Font.Base.title1Bold,
                alignment: .center,
                accessibilityTraits: .header
            ),
            GDSTextViewModel(
                title: GDSLocalisedString(stringKey: explanation),
                titleFont: DesignSystem.Font.Base.body,
                alignment: .left
            )
        ]

        if let footerButtonTitle, let footerButtonAction {
            self.footer = [
                GDSButtonViewModel(
                    title: footerButtonTitle,
                    style: .primary,
                    buttonAction: .action(footerButtonAction),
                    accessibilityIdentifier: "footer-button",
                    horizontalPadding: .horizontal(16)
                )
            ]
        } else {
            self.footer = []
        }
    }
}
