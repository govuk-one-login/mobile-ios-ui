@_spi(unstable) import DesignSystem
import UIKit

public struct TestViewControllerViewModel: ScreenViewModel {
    public let body: [any ContentViewModel]
    public var moveableFooter: [any ContentViewModel]
    public var footer: [any ContentViewModel]
}

class ViewController: UIViewController {
    var viewModel: TestViewControllerViewModel {
        TestViewControllerViewModel(
            body: [
//                GDSCardViewModel(
//                    showShadow: true,
//                    dismissAction: .action({ })
//                ) {
//                    GDSCardImageViewModel(
//                        image: UIImage(named: "placeholder") ?? UIImage(),
//                        contentMode: .scaleAspectFit
//                    )
//                    GDSCardTextViewModel(
//                        title: GDSLocalisedString(
//                            stringLiteral: "Here is the caption for the picture",
//                            stringAttributes: [("Here is the caption for the picture",
//                                                [.foregroundColor: DesignSystem.Color.Icons.success])]
//                        ),
//                        verticalPadding: .vertical(8)
//                    )
//                    GDSCardTextViewModel(
//                        title: "A title for the component for a quick introduction",
//                        titleFont: DesignSystem.Font.Base.title1Bold,
//                        verticalPadding: .bottom(8)
//                    )
//                    GDSCardTextViewModel(
//                        title: "A subtitle for the componenet which can be used to describe it's purpose",
//                        verticalPadding: .bottom(8)
//                    )
//                    GDSCardDividerViewModel(
//                        verticalPadding: .bottom(8)
//                    )
//                    GDSButtonViewModel(
//                        title: "Secondary Button",
//                        style: .secondary,
//                        buttonAction: .action({ }),
//                        verticalPadding: .bottom(8),
//                        horizontalPadding: .horizontal(16)
//                    )
//                    GDSButtonViewModel(
//                        title: "Primary Button",
//                        style: .primary,
//                        buttonAction: .action({ }),
//                        verticalPadding: .bottom(16),
//                        horizontalPadding: .horizontal(16)
//                    )
//                },
//                GDSCardViewModel(
//                    showShadow: true,
//                    dismissAction: .action({ })
//                ) {
//                    GDSCardTitleViewModel(
//                        title: "A title for the component",
//                        verticalPadding: .bottom(8),
//                        horizontalPadding: .leading(16)
//                    )
//                    GDSCardTextViewModel(
//                        title: "A subtitle for the componenet which can be used to describe it's purpose",
//                        verticalPadding: .bottom(8)
//                    )
//                    GDSCardDividerViewModel(
//                        verticalPadding: .bottom(8)
//                    )
//                    GDSButtonViewModel(
//                        title: "Secondary Button",
//                        icon: .arrowUpRight,
//                        style: .secondary.adjusting(
//                            alignment: .leading,
//                            contentInsets: NSDirectionalEdgeInsets(
//                                top: DesignSystem.Spacing.small,
//                                leading: .zero,
//                                bottom: DesignSystem.Spacing.small,
//                                trailing: DesignSystem.Spacing.default
//                            )
//                        ),
//                        buttonAction: .action({ }),
//                        verticalPadding: .bottom(8),
//                        horizontalPadding: .horizontal(16)
//                    )
//                },
                DefaultGDSListViewModel(
                    title: "Numbered List",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "Item 1",
                        GDSLocalisedString(
                            stringLiteral: "This is bold, this is not",
                            stringAttributes: [("This is bold",
                                                [.font: DesignSystem.Font.Base.bodyBold])]
                        ),
                        "Item 3"
                    ],
                    style: .numbered
                ),
                DefaultGDSListViewModel(
                    title: "Bulleted List",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "Item 1",
                        "Item 2",
                        "Item 3"
                    ],
                    style: .bulleted
                ),
                DefaultGDSListViewModel(
                    items: [
                        "Item 1 - this is an example of a numbered list without a title, long texts should wrap!",
                        "Item 2",
                        "Item 3"
                    ],
                    style: .numbered
                )
            ],
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
