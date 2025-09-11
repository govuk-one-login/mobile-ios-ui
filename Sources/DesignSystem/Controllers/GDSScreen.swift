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
            spacing: 0,
            distribution: .fill
        )
        result.accessibilityIdentifier = "gds-screen-container-stack-view"
        return result
    }()
    
    private lazy var scrollView: UIScrollView = {
        let result = UIScrollView()
        result.contentLayoutGuide.widthAnchor.constraint(equalTo: result.widthAnchor).isActive = true
        result.addSubview(scrollViewOuterStackView)
        scrollViewOuterStackView.bindToSuperviewEdges()
        result.accessibilityIdentifier = "gds-screen-container-scrollview"
        return result
    }()
    
    private lazy var scrollViewOuterStackView: UIStackView = {
        let result = UIStackView(
            views: [
                topSpacer,
                scrollViewInnerStackView,
                bottomSpacer
            ],
            distribution: .equalSpacing
        )
        result.accessibilityIdentifier = "gds-screen-outer-stack-view"
        return result
    }()
    
    private lazy var topSpacer: UIView = {
        let result = UIView()
        result.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return result
    }()
    
    private lazy var bottomSpacer: UIView = {
        let result = UIView()
        result.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
        let result = UIStackView(
            views: viewModel.footer.map { $0.createUIView() },
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
        result.accessibilityIdentifier = "gds-screen-bottom-stack-view"
        return result
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
        scrollViewOuterStackView.heightAnchor.constraint(
            greaterThanOrEqualTo: scrollView.heightAnchor
        ).isActive = true
    }
}
