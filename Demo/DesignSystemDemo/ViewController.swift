@_spi(unstable) import DesignSystem
import Foundation
import UIKit

public struct TestViewControllerViewModel: ScreenViewModel {
    public let body: [any ContentViewModel]
    public var moveableFooter: [any ContentViewModel]
    public var footer: [any ContentViewModel]
}

class ViewController: UIViewController {
    var viewModel: TestViewControllerViewModel {
        TestViewControllerViewModel(
            body: bodyContent,
            moveableFooter: [],
            footer: []
        )
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    lazy var stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        stackview.spacing = 16
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layoutMargins = .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        return stackview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Design System Demo"

        scrollView.addSubview(stackview)
        view.addSubview(scrollView)
        configureConstraints()
        addViewsToStack()
    }

    func pushGDSScreen() {
        let screen = GDSScreen(viewModel: gdsScreenViewModel)
        navigationController?.pushViewController(screen, animated: true)
    }

    func addViewsToStack() {
        viewModel.body.forEach {
            stackview.addArrangedSubview($0.createUIView())
        }
    }

    func configureConstraints() {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                stackview.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
                stackview.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
                stackview.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                stackview.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
            ]
        )
    }
}

// MARK: - View Models

extension ViewController {
    var bodyContent: [any ContentViewModel] {
        [
            GDSButtonViewModel(
                title: "Push GDSScreen",
                style: .secondary,
                buttonAction: .action({ [weak self] in
                    self?.pushGDSScreen()
                })
            ),
            GDSTextViewModel(
                title: "Simple test label",
                titleFont: DesignSystem.Font.Base.body,
                alignment: .left
            ),
            GDSErrorIconTitleViewModel(
                icon: .error,
                errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: .header,
                    verticalPadding: .bottom(8)
                )
            ),
            GDSErrorIconTitleViewModel(
                icon: .warning,
                errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: UIAccessibilityTraits.none,
                    verticalPadding: .bottom(8)
                )
            ),
            GDSMultiRowViewModel(rows: [
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 1"),
                    detailConfig: StyledText(text: "20"),
                    iconStyle: IconStyle(icon: "chevron.right"),
                    type: .regular
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 2", colour: .red),
                    subtitleConfig: StyledText(text: "Test Subtitle"),
                    detailConfig: StyledText(text: "14"),
                    image: UIImage(named: "exampleImage"),
                    iconStyle: IconStyle(
                        icon: "arrow.up.right",
                        colour: .blue,
                        accessibilityHint: "this is icon alt text"
                    )
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 3"),
                    image: UIImage(named: "vetCard"),
                    iconStyle: .arrowUpRight,
                    action: .action(
                        {
                            UIApplication.shared.open(URL(string: "https://www.google.com")!)
                        }
                    )
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 4")
                )
            ]),
            GDSListViewModel(
                title: GDSLocalisedString(stringKey: "Test numbered list view"),
                titleConfig: TitleConfig(
                    font: DesignSystem.Font.Base.headline, isHeader: true),
                items: [
                    GDSLocalisedString(stringKey: "first numbered list item"),
                    GDSLocalisedString(stringKey: "second numbered list item"),
                    GDSLocalisedString(
                        stringLiteral: "This is a linked phrase",
                        stringAttributes: .init(
                            symbol: UIImage(
                                systemName: "arrow.up.right",
                                withConfiguration: UIImage.SymbolConfiguration(font: DesignSystem.Font.Base.body)
                            )?.withTintColor(DesignSystem.Color.Links.default, renderingMode: .alwaysOriginal),
                            position: .trailing,
                            attributes: [
                                ("This is a ",
                                 [.foregroundColor: DesignSystem.Color.Text.primary,
                                  .font: DesignSystem.Font.Base.body]
                                ),
                                ("linked phrase",
                                 [.foregroundColor: DesignSystem.Color.Links.default,
                                  .font: DesignSystem.Font.Base.body,
                                  .link: URL(string: "https://www.gov.uk")!]
                                )
                            ]
                        )
                    )
                ],
                style: .numbered
            ),
            GDSCardViewModel(
                showShadow: true,
                dismissAction: .action({ })
            ) {
                GDSImageViewModel(
                    image: UIImage(named: "placeholder") ?? UIImage(),
                    contentMode: .scaleAspectFit
                )
                GDSTextViewModel(
                    title: GDSLocalisedString(
                        stringLiteral: "Here is the caption for the picture",
                        stringAttributes: [("Here is the caption for the picture",
                                            [.foregroundColor: DesignSystem.Color.Icons.success])]
                    ),
                    verticalPadding: .vertical(8)
                )
                GDSTextViewModel(
                    title: "A title for the component for a quick introduction",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    verticalPadding: .bottom(8)
                )
                GDSTextViewModel(
                    title: "A subtitle for the componenet which can be used to describe it's purpose",
                    verticalPadding: .bottom(8)
                )
                GDSDividerViewModel(
                    verticalPadding: .bottom(8)
                )
                GDSButtonViewModel(
                    title: "Secondary Button",
                    style: .secondary,
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(8),
                    horizontalPadding: .horizontal(16)
                )
                GDSButtonViewModel(
                    title: "Primary Button",
                    style: .primary,
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(16),
                    horizontalPadding: .horizontal(16)
                )
            },
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
                    title: "A subtitle for the componenet which can be used to describe it's purpose",
                    verticalPadding: .bottom(8)
                )
                GDSDividerViewModel(
                    verticalPadding: .bottom(8)
                )
                GDSButtonViewModel(
                    title: "Secondary Button",
                    icon: .arrowUpRight,
                    style: .secondary.adjusting(
                        alignment: .leading,
                        contentInsets: NSDirectionalEdgeInsets(
                            top: DesignSystem.Spacing.small,
                            leading: .zero,
                            bottom: DesignSystem.Spacing.small,
                            trailing: DesignSystem.Spacing.default
                        )
                    ),
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(8),
                    horizontalPadding: .horizontal(16)
                )
            }
        ]
    }

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
