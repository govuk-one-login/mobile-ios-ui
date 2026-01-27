@_spi(unstable) import DesignSystem
import Foundation
import UIKit

public struct TestViewControllerViewModel: GDSScreenViewModel {
    public let screenStyle: GDSScreenStyle = .centreLeading
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
                    verticalPadding: .bottom(8)
                )
                ),
                GDSTextViewModel(
                    title: "Please check your internet connection and try again.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .center,
                    verticalPadding: .bottom(8)
                )
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
