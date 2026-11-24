import UIKit

/// Landscape split layout for `GDSScreen`: the body scrolls in the leading half, and
/// the footer content sits in the trailing half. The movable footer lives in its own
/// vertical scroll view above the fixed footer, which stays pinned to the bottom.
extension GDSScreen {
    /// The split layout is used whenever the screen is wider than it is tall.
    ///
    /// This is deliberately geometry rather than a size class: on iPhone Duo's inner
    /// display landscape is regular in both directions (as is iPad), so a compact
    /// vertical size class would only match iPhone and the Duo's outer display.
    var shouldUseSplitLayout: Bool {
        view.bounds.width > view.bounds.height
    }
    
    // MARK: - View construction
    
    /// Trailing half of the split layout.
    func makeSplitFooterColumn() -> UIStackView {
        let result = UIStackView(
            views: [splitMovableScrollView],
            spacing: .zero,
            distribution: .fill
        )
        result.axis = .vertical
        result.accessibilityIdentifier = "gds-screen-split-footer-column"
        return result
    }
    
    /// Scrolls the movable footer. Fills the space above the fixed footer; the content
    /// is bottom aligned when shorter than that space and scrolls when taller.
    func makeSplitMovableScrollView() -> UIScrollView {
        let result = UIScrollView()
        result.contentInsetAdjustmentBehavior = .never
        result.accessibilityIdentifier = "gds-screen-split-movable-scrollview"
        result.addSubview(splitMovableContentView)
        splitMovableContentView.addSubview(splitMovableStackView)
        splitMovableContentView.translatesAutoresizingMaskIntoConstraints = false
        splitMovableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splitMovableContentView.topAnchor.constraint(equalTo: result.contentLayoutGuide.topAnchor),
            splitMovableContentView.bottomAnchor.constraint(equalTo: result.contentLayoutGuide.bottomAnchor),
            splitMovableContentView.leadingAnchor.constraint(equalTo: result.contentLayoutGuide.leadingAnchor),
            splitMovableContentView.trailingAnchor.constraint(equalTo: result.contentLayoutGuide.trailingAnchor),
            splitMovableContentView.widthAnchor.constraint(equalTo: result.frameLayoutGuide.widthAnchor),
            splitMovableContentView.heightAnchor.constraint(
                greaterThanOrEqualTo: result.frameLayoutGuide.heightAnchor
            ),
            splitMovableStackView.topAnchor.constraint(greaterThanOrEqualTo: splitMovableContentView.topAnchor),
            splitMovableStackView.bottomAnchor.constraint(equalTo: splitMovableContentView.bottomAnchor),
            splitMovableStackView.leadingAnchor.constraint(equalTo: splitMovableContentView.leadingAnchor),
            splitMovableStackView.trailingAnchor.constraint(equalTo: splitMovableContentView.trailingAnchor)
        ])
        return result
    }
    
    /// Holds the movable footer views while split.
    func makeSplitMovableStackView() -> UIStackView {
        let result = UIStackView(views: [], spacing: .zero, distribution: .fill)
        result.axis = .vertical
        result.isLayoutMarginsRelativeArrangement = true
        // Margins are set explicitly in `updateSplitFooterLayout()`.
        result.insetsLayoutMarginsFromSafeArea = false
        result.accessibilityIdentifier = "gds-screen-split-movable-stack-view"
        return result
    }
    
    /// Extends the footer background under the safe areas (top, trailing, bottom)
    /// while split. Sits behind the container, so the footer's content still
    /// respects the safe area.
    func makeSplitFooterBackgroundView() -> UIView {
        let result = UIView()
        result.backgroundColor = viewModel.footerBackgroundColor
        result.isUserInteractionEnabled = false
        result.accessibilityIdentifier = "gds-screen-split-footer-background"
        return result
    }
    
    // MARK: - Layout
    
    func updateSplitLayoutIfNeeded() {
        let wantsSplit = shouldUseSplitLayout
        guard wantsSplit != isInSplitLayout else { return }
        if wantsSplit {
            enterSplitLayout()
        } else {
            exitSplitLayout()
        }
    }
    
    /// Keeps the split footer's visibility and margins in step with its content.
    /// Nothing moves between containers here: the movable footer always lives in the
    /// trailing half's scroll view while split.
    func updateSplitFooterLayout() {
        let hasFixedFooter = !viewModel.footer.isEmpty
        let hasMovableFooter = !movableFooterViews.isEmpty
        
        // With no footer content at all, the body takes the full width.
        splitFooterColumn.isHidden = !hasFixedFooter && !hasMovableFooter
        splitFooterBackgroundView.isHidden = splitFooterColumn.isHidden
        bottomStackView.isHidden = !hasFixedFooter
        
        // The fixed footer provides the bottom margin (and safe area) when present;
        // otherwise the movable footer is the lowest content and needs its own.
        let bottomSafeArea = viewModel.safeAreaEdgesToIgnore.contains(.bottom)
            ? view.safeAreaInsets.bottom
            : .zero
        splitMovableStackView.directionalLayoutMargins.bottom = hasFixedFooter
            ? .zero
            : DesignSystem.Spacing.default + bottomSafeArea
    }
    
    private func enterSplitLayout() {
        // Any portrait move into the body scroll view is undone first.
        if isMovableFooterInScrollView {
            movableFooterToBottomStackView()
        }
        
        // Movable footer: bottom stack -> the trailing half's scroll view.
        for movableView in movableFooterViews {
            bottomStackView.removeArrangedSubview(movableView)
            movableView.removeFromSuperview()
            splitMovableStackView.addArrangedSubview(movableView)
        }
        
        // Fixed footer: pinned beneath the scroll view in the trailing half.
        containerStackView.removeArrangedSubview(bottomStackView)
        bottomStackView.removeFromSuperview()
        splitFooterColumn.addArrangedSubview(bottomStackView)
        
        splitFooterBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(splitFooterBackgroundView, belowSubview: containerStackView)
        // Must be in the hierarchy before any constraint spanning it is activated.
        containerStackView.addArrangedSubview(splitFooterColumn)
        splitFooterConstraints = [
            // Background runs from the footer's leading edge to the screen edges.
            splitFooterBackgroundView.leadingAnchor.constraint(equalTo: splitFooterColumn.leadingAnchor),
            splitFooterBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            splitFooterBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splitFooterBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(splitFooterConstraints)
        
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fillEqually
        isInSplitLayout = true
        updateSplitFooterLayout()
    }
    
    private func exitSplitLayout() {
        NSLayoutConstraint.deactivate(splitFooterConstraints)
        splitFooterConstraints = []
        containerStackView.removeArrangedSubview(splitFooterColumn)
        splitFooterColumn.removeFromSuperview()
        splitFooterBackgroundView.removeFromSuperview()
        bottomStackView.removeFromSuperview()
        
        // Movable footer: back above the fixed footer in the bottom stack.
        for movableView in movableFooterViews {
            splitMovableStackView.removeArrangedSubview(movableView)
            movableView.removeFromSuperview()
        }
        for movableView in movableFooterViews.reversed() {
            bottomStackView.insertArrangedSubview(movableView, at: .zero)
        }
        bottomStackView.isHidden = bottomStackView.arrangedSubviews.isEmpty
        
        containerStackView.addArrangedSubview(bottomStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        isInSplitLayout = false
    }
}
