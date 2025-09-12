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
        result.accessibilityIdentifier = "gds-screen-container-scrollview"
        return result
    }()
    
    private lazy var scrollViewOuterStackView: UIStackView = {
        var subviews = [
            scrollViewInnerStackView,
            UIView()
        ]
        if viewModel is GDSCentreAlignedScreenViewModel {
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
            views: viewModel.body.map { $0.createUIView() },
            spacing: DesignSystem.Spacing.small,
            distribution: .equalSpacing
        )
        result.layoutMargins = UIEdgeInsets(
            top: DesignSystem.Spacing.small,
            left: DesignSystem.Spacing.default,
            bottom: DesignSystem.Spacing.small,
            right: DesignSystem.Spacing.default
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.accessibilityIdentifier = "gds-screen-inner-stack-view"
        return result
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let footerContent = movableFooterViews + viewModel.footer.map { $0.createUIView() }
        let result = UIStackView(
            views: footerContent,
            spacing: DesignSystem.Spacing.small,
            distribution: .fill
        )
        result.layoutMargins = UIEdgeInsets(
            top: DesignSystem.Spacing.small,
            left: DesignSystem.Spacing.default,
            bottom: DesignSystem.Spacing.default,
            right: DesignSystem.Spacing.default
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.isHidden = footerContent.isEmpty
        result.accessibilityIdentifier = "gds-screen-bottom-stack-view"
        return result
    }()
    
    private lazy var movableFooterViews: [UIView] = {
        viewModel.movableFooter.map { $0.createUIView() }
    }()
    
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
                equalTo: scrollView.heightAnchor
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
    
    private(set) var isMovableContentInScrollView = false
    
    private var movableFooterViewsHeight: CGFloat {
        movableFooterViews
            .map(\.intrinsicContentSize.height)
            .reduce(.zero, +) + (Double(movableFooterViews.count) * DesignSystem.Spacing.small)
    }
        
    private func checkBottomStackHeight() {
        let screenHeight = UIScreen.main.bounds.height
        let bottomStackHeight = bottomStackView.frame.height
        
        // if bottom stack covers more than 1/3 of screen
        if bottomStackHeight > screenHeight / 3,
           !isMovableContentInScrollView {
            moveFootnoteToScrollView()
        } else if bottomStackHeight + movableFooterViewsHeight < screenHeight / 3,
                  isMovableContentInScrollView {
            moveFootnoteToBottomStackView()
        }
    }
    
    private func moveFootnoteToScrollView() {
        // remove footnote from bottom stack
        for index in movableFooterViews {
            bottomStackView.removeArrangedSubview(index)
            index.removeFromSuperview()
        }
        
        // add to scroll view
        for index in movableFooterViews {
            scrollViewInnerStackView.addArrangedSubview(index)
        }
        
        isMovableContentInScrollView = true
    }
    
    private func moveFootnoteToBottomStackView() {
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
        isMovableContentInScrollView = false
    }
}
