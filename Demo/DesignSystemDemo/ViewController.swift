@_spi(unstable) import DesignSystem
import Foundation
import UIKit

public struct TestViewControllerViewModel: GDSScreenViewModel {
    public var screenStyle: GDSScreenStyle
    public let body: [any ContentViewModel]
    public var movableFooter: [any ContentViewModel]
    public var footer: [any ContentViewModel]
}

/// The demo's root screen. Presents a menu of design system categories and
/// screen patterns; selecting a row pushes a dedicated screen for that item.
class ViewController: UITableViewController {

    // MARK: - Menu definition

    private enum MenuItem: CaseIterable {
        // Component categories
        case buttons
        case progressIndicator
        case text
        case errorIcons
        case rows
        case lists
        case cards
        // Screen patterns
        case gdsScreen
        case noScrollViewScreen
        case collectionViewScreen
        case navigationBarButton

        var title: String {
            switch self {
            case .buttons: return "Buttons"
            case .progressIndicator: return "Progress Indicator"
            case .text: return "Text"
            case .errorIcons: return "Error Icons"
            case .rows: return "Rows"
            case .lists: return "Lists"
            case .cards: return "Cards"
            case .gdsScreen: return "GDSScreen"
            case .noScrollViewScreen: return "No Scroll View GDSScreen"
            case .collectionViewScreen: return "Collection View GDSScreen"
            case .navigationBarButton: return "NavigationBarButton Examples"
            }
        }

        var sectionTitle: String {
            switch self {
            case .buttons, .progressIndicator, .text, .errorIcons, .rows, .lists, .cards:
                return "Components"
            case .gdsScreen, .noScrollViewScreen, .collectionViewScreen, .navigationBarButton:
                return "Screens & Patterns"
            }
        }
    }

    private let sections: [(title: String, items: [MenuItem])] = {
        let grouped = Dictionary(grouping: MenuItem.allCases, by: { $0.sectionTitle })
        // Preserve a stable, intentional section order.
        return ["Components", "Screens & Patterns"].compactMap { key in
            guard let items = grouped[key] else { return nil }
            return (title: key, items: items)
        }
    }()

    init() {
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Design System Demo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        sections[section].items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Table delegate

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        navigate(to: item)
    }

    private func navigate(to item: MenuItem) {
        switch item {
        case .buttons:
            pushComponentScreen(
                title: item.title,
                content: ComponentCatalog.buttons(present: { [weak self] alert in
                    self?.present(alert, animated: true)
                })
            )
        case .progressIndicator:
            pushComponentScreen(title: item.title, content: ComponentCatalog.progressIndicators)
        case .text:
            pushComponentScreen(title: item.title, content: ComponentCatalog.text)
        case .errorIcons:
            pushComponentScreen(title: item.title, content: ComponentCatalog.errorIcons)
        case .rows:
            pushComponentScreen(title: item.title, content: ComponentCatalog.rows)
        case .lists:
            pushComponentScreen(title: item.title, content: ComponentCatalog.lists)
        case .cards:
            pushComponentScreen(title: item.title, content: ComponentCatalog.cards)
        case .gdsScreen:
            pushGDSScreen()
        case .noScrollViewScreen:
            pushNoScrollViewGDSScreen()
        case .collectionViewScreen:
            pushCollectionViewGDSScreen()
        case .navigationBarButton:
            pushNavigationBarButtonDemo()
        }
    }

    // MARK: - Navigation helpers

    private func pushComponentScreen(title: String, content: [any ContentViewModel]) {
        let screen = ComponentScreenViewController(title: title, content: content)
        navigationController?.pushViewController(screen, animated: true)
    }

    func pushGDSScreen() {
        let screen = GDSScreen(viewModel: gdsScreenViewModel)
        navigationController?.pushViewController(screen, animated: true)
    }

    func pushNoScrollViewGDSScreen() {
        let screen = GDSScreen(viewModel: gdsNoScrollViewScreenViewModel)
        navigationController?.pushViewController(screen, animated: true)
    }

    func pushCollectionViewGDSScreen() {
        let screen = GDSScreen(viewModel: gdsCollectionViewScreenViewModel)
        navigationController?.pushViewController(screen, animated: true)
    }

    func pushNavigationBarButtonDemo() {
        let demo = NavigationBarButtonDemoViewController(style: .insetGrouped)
        navigationController?.pushViewController(demo, animated: true)
    }
}

// MARK: - GDSScreen View Model

extension ViewController {
    var gdsScreenViewModel: GDSDemoScreenViewModel {
        GDSDemoScreenViewModel(
            body: [
                GDSTextViewModel(
                    title: "Simple test label",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                GDSListViewModel(
                    title: "Numbered List",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "Item 1",
                        "Item 2",
                        "Item 3"
                    ],
                    style: .numbered
                ),
                GDSCardViewModel(
                    showShadow: true,
                    dismissAction: .action({ })
                ) {
                    GDSCardTitleViewModel(
                        title: "A title for the component",
                        verticalPadding: .bottom(8),
                        horizontalPadding: .leading(16)
                    )
                    GDSTextViewModel(
                        title: "A subtitle for the component",
                        verticalPadding: .bottom(8)
                    )
                    GDSDividerViewModel(
                        verticalPadding: .bottom(8)
                    )
                    GDSButtonViewModel(
                        title: "Primary Button",
                        style: .primary,
                        buttonAction: .action({ }),
                        verticalPadding: .bottom(16),
                        horizontalPadding: .horizontal(16)
                    )
                }
            ],
            movableFooter: [],
            footer: [
                GDSButtonViewModel(
                    title: "Footer Button",
                    style: .primary,
                    buttonAction: .action({ })
                )
            ]
        )
    }
}
