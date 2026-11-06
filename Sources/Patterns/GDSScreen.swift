import UIKit

open class GDSScreen: BaseScreen, VoiceOverFocus {
    public var initialVoiceOverView: UIView {
        get throws {
            if viewModel.screenStyle.usesScrollView {
                guard let firstView = scrollViewInnerStackView.arrangedSubviews.first else {
                    throw VoiceOverFocusError.notAvailable
                }
                return firstView
            } else {
                // Body items are wrapped in UIStackView via configureAsStackView.
                // Filter by UIStackView to skip the trailing spacer view.
                guard let firstView = bodyContainerStackView.arrangedSubviews.first(where: { $0 is UIStackView }) else {
                    throw VoiceOverFocusError.notAvailable
                }
                return firstView
            }
        }
    }
    
    /// Directs keyboard / Full Keyboard Access focus as it enters this screen when
    /// the view model conforms to ``KeyboardFocus`` and names a view that exists in
    /// the hierarchy. Falls back to the system's default focus order otherwise.
    open override var preferredFocusEnvironments: [UIFocusEnvironment] {
        guard let focusProviding = viewModel as? KeyboardFocus,
              let identifier = focusProviding.preferredFocusAccessibilityIdentifier,
              let focusTarget = view.firstSubview(withAccessibilityIdentifier: identifier) else {
            return super.preferredFocusEnvironments
        }
        return [focusTarget]
    }
    
    private(set) lazy var containerStackView: UIStackView = {
        let primaryContent: UIView = viewModel.screenStyle.usesScrollView
            ? scrollView
            : bodyContainerStackView
        let result = UIStackView(
            views: [
                primaryContent,
                bottomStackView
            ],
            spacing: .zero,
            distribution: .fill
        )
        result.accessibilityIdentifier = "gds-screen-container-stack-view"
        return result
    }()
    
    private(set) lazy var bodyContainerStackView: UIStackView = {
        let bodyViews = viewModel.body.map { configureAsStackView($0) }
        // A spacer view absorbs remaining vertical space so that body content
        // stays at its intrinsic size at the top. Without this, the stack view's
        // .fill distribution would stretch body items to fill the available area,
        // causing buttons and labels to grow beyond their intended height.
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        spacer.isAccessibilityElement = false
        spacer.accessibilityElementsHidden = true
        let result = UIStackView(
            views: bodyViews + [spacer],
            spacing: .zero,
            alignment: viewModel.screenStyle.horizontalAlignment,
            distribution: .fill
        )
        result.isLayoutMarginsRelativeArrangement = true
        result.directionalLayoutMargins.bottom = DesignSystem.Spacing.small
        result.accessibilityIdentifier = "gds-screen-body-container-stack-view"
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
    
    public private(set) lazy var scrollViewInnerStackView: UIStackView = {
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
        result.backgroundColor = viewModel.footerBackgroundColor
        return result
    }()
    
    private(set) lazy var movableFooterViews: [UIView] = {
        viewModel.movableFooter.map { configureAsStackView($0) }
    }()
    
    /// The intrinsic height the movable footer will occupy at the given width
    /// and the current Dynamic Type size.
    ///
    /// Measured with `systemLayoutSizeFitting` rather than read from `frame` so the
    /// value is independent of which container the footer currently lives in and
    /// does not depend on a layout pass having settled. Falls back to summed frame
    /// heights when no usable width is available yet (pre-layout / degenerate
    /// state), as a best-effort estimate until the next layout pass.
    func movableFooterViewsHeight(forWidth width: CGFloat) -> CGFloat {
        guard width > 0 else {
            return movableFooterViews
                .map(\.frame.height)
                .reduce(.zero, +)
        }
        return movableFooterViews
            .map { view in
                view.systemLayoutSizeFitting(
                    CGSize(
                        width: width,
                        height: UIView.layoutFittingCompressedSize.height
                    ),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ).height
            }
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Movable footer logic only applies when using a scroll view.
        // When usesScrollView is false, body content manages its own scrolling
        // so there is no need to move footer items into the scroll view.
        guard viewModel.screenStyle.usesScrollView else { return }
        // Running this synchronously / not from detached Task { } makes sure
        // that the frames read in checkBottomStackHeight() are current.
        checkBottomStackHeight()
    }
    
    private func setup() {
        view.addSubview(containerStackView)
        containerStackView.bindToSuperviewSafeArea(ignoringEdges: viewModel.safeAreaEdgesToIgnore)
        view.backgroundColor = viewModel.backgroundColor
        if viewModel.screenStyle.usesScrollView {
            addRelativeViewConstraints()
        }
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
        // Read the container size once and fold the guards together. We still
        // bail when there is no usable height (pre-layout) since the threshold is
        // derived from it. The width is passed through to the measurement helper,
        // which falls back to summed frame heights as a best-effort estimate if
        // the width is not yet resolved; the next layout pass recalculates.
        let size = containerStackView.bounds.size
        guard size.height > 0 else { return }

        let threshold = size.height / 3
        // Measure the footer the same way in both branches so the move-out and
        // move-back decisions are symmetric. Previously each branch measured a
        // different thing (the bottom stack's frame height on the way out, that
        // plus the footer's height on the way back), in different layout contexts.
        // That meant a change which grew the footer past the threshold (e.g.
        // larger Dynamic Type) could not always be reversed when it shrank back,
        // stranding the footer in the scroll view.
        let footerHeight = movableFooterViewsHeight(forWidth: size.width)

        if !isMovableFooterInScrollView, footerHeight > threshold {
            movableFooterToScrollView()
        } else if isMovableFooterInScrollView, threshold > footerHeight {
            movableFooterToBottomStackView()
        }
    }
    
    func movableFooterToScrollView() {
        // remove footer from bottom stack
        for view in movableFooterViews {
            bottomStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // add to scroll view
        for view in movableFooterViews {
            scrollViewInnerStackView.addArrangedSubview(view)
        }
        
        // Collapse the empty bottom stack so it stops occupying height under the
        // container. Leaving it visible-but-empty makes the "should the footer
        // return?" check over-report the pinned height, and can strand the footer
        // in scroll view.
        bottomStackView.isHidden = bottomStackView.arrangedSubviews.isEmpty
        
        isMovableFooterInScrollView = true
    }
    
    func movableFooterToBottomStackView() {
        // remove from scroll view
        for view in movableFooterViews {
            scrollViewInnerStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // add to stack
        for view in movableFooterViews.reversed() {
            bottomStackView.insertArrangedSubview(view, at: .zero)
        }
        
        // The stack now has content again, so make sure it is visible.
        bottomStackView.isHidden = bottomStackView.arrangedSubviews.isEmpty
        
        // No explicit layoutIfNeeded(): we've already mutated the arranged
        // subviews, so the layout is invalidated. Manually calling
        // layoutIfNeeded() only causes re-entry in this cycle, since this runs
        // synchronously from viewDidLayoutSubviews. UIKit will render on the
        // next pass.
        isMovableFooterInScrollView = false
    }
    
    private func configureAsStackView(_ view: some ContentViewModel) -> UIStackView {
        // Content that opts into hugging its intrinsic width (e.g. an outline
        // button) must not have both horizontal edges pinned by the wrapper stack,
        // otherwise it would be stretched to fill. Use its preferred alignment
        // instead of `.fill` in that case. All other content keeps `.fill`, so
        // existing layouts are unchanged.
        let alignment: UIStackView.Alignment
        if let fillProviding = view as? ContentFillProviding,
           fillProviding.hugsContentWidth {
            alignment = fillProviding.contentFillAlignment
        } else {
            alignment = .fill
        }
        let stackView = UIStackView(
            views: view.createUIView(),
            spacing: .zero,
            alignment: alignment,
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
