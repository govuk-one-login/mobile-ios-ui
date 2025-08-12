@_spi(unstable) import DesignSystem
import UIKit

public struct TestViewControllerViewModel: ScreenViewModel {
    public let body: [ContentItem]
    public var moveableFooter: [ContentItem]
    public var footer: [ContentItem]
}

class ViewController: UIViewController {
    var viewModel: TestViewControllerViewModel {
        TestViewControllerViewModel(
            body: [
                GDSContentCardViewModel(
                    items: [
                        ContentImageViewModel(
                            image: UIImage(named: "DemoImage")!,
                            contentMode: .scaleAspectFit
                        ),
                        ContentTitleViewModel(
                            title: "Title",
                            titleFont: DesignSystem.Font.Base.title1,
                            verticalPadding: .vertical(0)
                        ),
                        ContentSubtitleViewModel(
                            title: "Title",
                            verticalPadding: .vertical(0)
                        ),
                        DividerViewModel(
                            height: 1,
                            colour: .separator,
                            verticalPadding: .vertical(0)
                        ),
                        GDSButtonViewModel(
                            title: "Secondary Button",
                            style: .secondary,
                            buttonAction: .action({ }),
                            verticalPadding: .vertical(0)
                        ),
                        GDSButtonViewModel(
                            title: "Primay Button",
                            style: .primary,
                            buttonAction: .action({ }),
                            verticalPadding: .bottom(16)
                        )
                    ],
                    showShadow: true,
                    dismissAction: {
                    }
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
            stackview.addArrangedSubview($0.uiView)
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
