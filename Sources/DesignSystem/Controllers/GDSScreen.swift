import UIKit

open class GDSScreen: BaseViewController, VoiceOverFocus {
    public let viewModel: GDSScreenViewModel
    
    public var initialVoiceOverView: UIView {
        scrollViewInnerStackView.arrangedSubviews.first ?? UIView()
    }
    
    private lazy var containerStackView: UIStackView = {
        let result = UIStackView(
            views: [
                scrollView,
                bottomStackView
            ],
            spacing: .zero,
            distribution: .fill
        )
        result.accessibilityIdentifier = "gds-screen-container-stack-view"
        return result
    }()
    
    private lazy var scrollView: UIScrollView = {
        let result = UIScrollView()
        result.addSubview(scrollViewOuterStackView)
        scrollViewOuterStackView.bindToSuperviewEdges()
        result.accessibilityIdentifier = "gds-screen-scrollview"
        return result
    }()
    
    private lazy var scrollViewOuterStackView: UIStackView = {
        var subviews = [
            scrollViewInnerStackView,
            UIView()
        ]
        if viewModel.screenStyle.verticalAlignment == .center {
            subviews.insert(UIView(), at: .zero)
        }
        let result = UIStackView(
            views: subviews,
            spacing: .zero,
            distribution: .equalSpacing
        )
        result.accessibilityIdentifier = "gds-screen-outer-stack-view"
        return result
    }()
    
    private lazy var scrollViewInnerStackView: UIStackView = {
        let result = UIStackView(
            views: viewModel.body.map { configureAsStackView($0) },
            spacing: .zero,
            alignment: viewModel.screenStyle.horizontalAlignment,
            distribution: .equalSpacing
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.directionalLayoutMargins.bottom = DesignSystem.Spacing.small
        result.accessibilityIdentifier = "gds-screen-inner-stack-view"
        return result
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let footerContent = movableFooterViews + viewModel.footer.map { configureAsStackView($0) }
        let result = UIStackView(
            views: footerContent,
            spacing: .zero,
            distribution: .fill
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.directionalLayoutMargins.bottom = DesignSystem.Spacing.default
        result.isHidden = footerContent.isEmpty
        result.accessibilityIdentifier = "gds-screen-bottom-stack-view"
        return result
    }()
    
    private lazy var movableFooterViews: [UIView] = {
        viewModel.movableFooter.map { configureAsStackView($0) }
    }()
    
    private func configureAsStackView(_ view: some ContentViewModel) -> UIStackView {
        let stackView = UIStackView(
            views: view.createUIView(),
            spacing: .zero,
            alignment: .fill,
            distribution: .fill
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: view.verticalPadding?.topPadding ?? .zero,
            leading: view.horizontalPadding?.leadingPadding ?? .zero,
            bottom: view.verticalPadding?.bottomPadding ?? .zero,
            trailing: view.horizontalPadding?.trailingPadding ?? .zero
        )
        return stackView
    }
    
    public init(
        viewModel: GDSScreenViewModel
    ) {
        self.viewModel = viewModel
        super.init(
            viewModel: viewModel as? BaseViewModel,
            nibName: nil,
            bundle: Bundle.module
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(containerStackView)
        containerStackView.bindToSuperviewSafeArea()
        view.backgroundColor = .systemBackground
        addRelativeViewConstraints()
    }
    
    private func addRelativeViewConstraints() {
        NSLayoutConstraint.activate([
            scrollViewOuterStackView.heightAnchor.constraint(
                greaterThanOrEqualTo: scrollView.heightAnchor
            ),
            scrollViewOuterStackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor
            )
        ])
    }
        
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Defer to ensure layout is finished
        Task {
            checkBottomStackHeight()
        }
    }
    
    private(set) var isMovableFooterInScrollView = false
    
    private var movableFooterViewsHeight: CGFloat {
        movableFooterViews
            .map(\.frame.height)
            .reduce(.zero, +)
    }
        
    private func checkBottomStackHeight() {
        let screenHeight = containerStackView.frame.height
        let bottomStackHeight = bottomStackView.frame.height
        
        // if bottom stack covers more than 1/3 of screen
        if !isMovableFooterInScrollView, bottomStackHeight > screenHeight / 3 {
            movableFooterToScrollView()
        } else if isMovableFooterInScrollView,
                  screenHeight / 3 > bottomStackHeight + movableFooterViewsHeight {
            movableFooterToBottomStackView()
        }
    }
    
    private func movableFooterToScrollView() {
        // remove footnote from bottom stack
        for index in movableFooterViews {
            bottomStackView.removeArrangedSubview(index)
            index.removeFromSuperview()
        }
        
        // add to scroll view
        for index in movableFooterViews {
            scrollViewInnerStackView.addArrangedSubview(index)
        }
        
        isMovableFooterInScrollView = true
    }
    
    private func movableFooterToBottomStackView() {
        // remove from scroll view
        for index in movableFooterViews {
            scrollViewInnerStackView.removeArrangedSubview(index)
            index.removeFromSuperview()
        }
        
        // add to stack
        for index in movableFooterViews {
            bottomStackView.insertArrangedSubview(index, at: .zero)
        }
        
        view.layoutIfNeeded()
        isMovableFooterInScrollView = false
    }
}
