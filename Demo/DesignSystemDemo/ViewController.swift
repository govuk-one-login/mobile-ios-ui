@_spi(unstable) import DesignSystem
import Foundation
import UIKit

public struct TestViewControllerViewModel: GDSScreenViewModel {
    public let screenStyle: GDSScreenStyle = .top
    public let body: [any ContentViewModel]
    public var movableFooter: [any ContentViewModel]
    public var footer: [any ContentViewModel]
}

class ViewController: UIViewController {
    var viewModel: TestViewControllerViewModel {
        TestViewControllerViewModel(
            body: [
                GDSErrorIconTitleViewModel(icon: .error, errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: .header,
                    verticalPadding: .bottom(8)
                )
                ),
                GDSTextViewModel(
                    title: "Please check your internet connection and try again.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .center,
                    verticalPadding: .bottom(8)
                ),
                GDSErrorIconTitleViewModel(icon: .warning, errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: [.staticText],
                    verticalPadding: .bottom(8)
                )
                ),
                GDSTextViewModel(
                    title: "Please check your internet connection and try again.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .center,
                    verticalPadding: .bottom(8)
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
                        iconStyle: IconStyle(icon: "arrow.up.right", colour: .blue, accessibilityHint: "this is icon alt text")
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
                    title: "Numbered List",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "take a photo",
                        GDSLocalisedString(
                            stringKey: "This is bold, this is not",
                            stringAttributes: [("This is bold",
                                                [.font: UIFont(.body, weight: .bold)])]
                        ),
                        "Item 2",
                        "Item 3"
                    ],
                    style: .numbered
                ),
                GDSListViewModel(
                    title: "Bulleted List",
                    titleConfig: (font: DesignSystem.Font.Base.body, isHeader: false),
                    items: [
                        "take a photo",
                        GDSLocalisedString(
                            stringLiteral: "second numbered list item",
                            stringAttributes: [("numbered list", [.font: DesignSystem.Font.Base.bodyBold])]
                        ),
                        "Item 3"
                    ],
                    style: .bulleted
                ),
                GDSListViewModel(
                    items: [
                        GDSLocalisedString(
                            stringLiteral: "Item 1 - this is an example of a numbered list without a title, long texts should wrap!",
                            stringAttributes: [("wrap!", [.font: DesignSystem.Font.Base.bodyBold])]
                        ),
                        "Item 2",
                        "Item 3"
                    ],
                    style: .numbered
                ),
                GDSListViewModel(
                    items: [
                        "Item 1",
                        GDSLocalisedString(
                            stringKey: "second bulleted list item",
                            stringAttributes: [("numbered list", [.font: DesignSystem.Font.Base.bodyBold])]
                        ),
                        "Item 3"
                    ],
                    style: .bulleted
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
            ],
            movableFooter: [],
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
        
        scrollView.addSubview(stackview)
        view.addSubview(scrollView)
        configureConstraints()
        addViewsToStack()
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
