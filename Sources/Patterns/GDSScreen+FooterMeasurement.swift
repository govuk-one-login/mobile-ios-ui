import UIKit

/// Measurements of the footer used to decide where the movable footer lives.
extension GDSScreen {
    /// The intrinsic height the movable footer will occupy at the given width
    /// and the current Dynamic Type size.
    ///
    /// Measured with `systemLayoutSizeFitting` rather than read from `frame` so the
    /// value is independent of which container the footer currently lives in. Falls
    /// back to summed frame heights when `width` is non-positive (pre-layout /
    /// degenerate state), as a best-effort estimate until the next layout pass.
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
    
    /// Height of the non-movable footer content, plus the stack's bottom margin, at
    /// the given width.
    ///
    /// The bottom margin is computed rather than read from `directionalLayoutMargins`:
    /// UIKit only folds the bottom safe-area inset into that value after the first
    /// layout, so reading it back under-measured the footer by the inset on the first
    /// pass. The inset applies when the container extends under the bottom safe area
    /// (footer background colour set).
    func fixedFooterHeight(forWidth width: CGFloat) -> CGFloat {
        let fixedViews = bottomStackView.arrangedSubviews.filter { !movableFooterViews.contains($0) }
        guard !fixedViews.isEmpty else { return .zero }
        let contentHeight = fixedViews
            .map { view in
                view.systemLayoutSizeFitting(
                    CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ).height
            }
            .reduce(.zero, +)
        let safeAreaBottom = viewModel.safeAreaEdgesToIgnore.contains(.bottom)
            ? view.safeAreaInsets.bottom
            : .zero
        return contentHeight + DesignSystem.Spacing.default + safeAreaBottom
    }
}
