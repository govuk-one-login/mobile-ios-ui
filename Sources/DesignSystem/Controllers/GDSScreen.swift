import UIKit

open class GDSScreen: BaseScreen, VoiceOverFocus {
public var initialVoiceOverView: UIView {
    get throws {
        guard let firstView = scrollViewInnerStackView.arrangedSubviews.first else {
            throw VoiceOverFocusError.notAvailable
        }
        return firstView
    }
}
    
    private(set) lazy var containerStackView: UIStackView = {
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
    
    private(set) lazy var scrollView: UIScrollView = {
        let result = UIScrollView()
        result.addSubview(scrollViewOuterStackView)
        scrollViewOuterStackView.bindToSuperviewEdges()
        result.accessibilityIdentifier = "gds-screen-scrollview"
        return result
    }()
    
    private(set) lazy var scrollViewOuterStackView: UIStackView = {
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
    
    private(set) lazy var scrollViewInnerStackView: UIStackView = {
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
    
    private(set) lazy var bottomStackView: UIStackView = {
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
    
    private(set) lazy var movableFooterViews: [UIView] = {
        viewModel.movableFooter.map { configureAsStackView($0) }
    }()
    
    var movableFooterViewsHeight: CGFloat {
        movableFooterViews
            .map(\.frame.height)
            .reduce(.zero, +)
    }
    
    private(set) var isMovableFooterInScrollView = false
    
    public let viewModel: GDSScreenViewModel
    
    public init(
        viewModel: GDSScreenViewModel
    ) {
        self.viewModel = viewModel
        super.init(
            viewModel: viewModel as? BaseViewModel,
            bundle: Bundle.module
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Defer to ensure layout is finished
        Task {
            checkBottomStackHeight()
        }
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
    
    func movableFooterToScrollView() {
        // remove footnote from bottom stack
        for view in movableFooterViews {
            bottomStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // add to scroll view
        for view in movableFooterViews {
            scrollViewInnerStackView.addArrangedSubview(view)
        }
        
        isMovableFooterInScrollView = true
    }
    
    func movableFooterToBottomStackView() {
        // remove from scroll view
        for view in movableFooterViews {
            scrollViewInnerStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // add to stack
        for view in movableFooterViews {
            bottomStackView.insertArrangedSubview(view, at: .zero)
        }
        
        view.layoutIfNeeded()
        isMovableFooterInScrollView = false
    }
    
    private func configureAsStackView(_ view: some ContentViewModel) -> UIStackView {
        let stackView = UIStackView(
            views: view.createUIView(),
            spacing: .zero,
            alignment: .fill,
            distribution: .fill
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: view.verticalPadding?.topPadding ?? viewModel.screenStyle.defaultVerticalPadding.topPadding,
            leading: view.horizontalPadding?.leadingPadding ?? viewModel.screenStyle.defaultHorizontalPadding.leadingPadding,
            bottom: view.verticalPadding?.bottomPadding ?? viewModel.screenStyle.defaultVerticalPadding.bottomPadding,
            trailing: view.horizontalPadding?.trailingPadding ?? viewModel.screenStyle.defaultHorizontalPadding.trailingPadding
        )
        return stackView
    }
}
