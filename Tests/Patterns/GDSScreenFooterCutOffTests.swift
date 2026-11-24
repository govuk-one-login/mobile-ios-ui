@testable import DesignSystem
import Testing
import UIKit

/// Coverage for where the movable footer's cut-off sits: the whole footer counts towards
/// it, it is a third of the full view height, and the decision does not change between
/// layout passes. Also checks the screen's measurement of its footer against the real
/// laid-out height, which guards against the two drifting apart.
@MainActor
struct GDSScreenFooterCutOffTests: GDSScreenFooterTesting {
    @Test("""
    The 1/3 cut-off applies to the whole footer, not just the movable content \
    (regression: with fixed footer content the footer reached about 1/2 of the screen \
    before anything moved)
    """)
    func wholeFooterCountsTowardsTheCutOff() {
        let viewModel = makeViewModel(movable: 3, fixed: 1)
        let measured = measureFooter(for: viewModel)
        // The fixed footer must really add height, or this test proves nothing.
        #expect(measured.total > measured.movable + 20)

        // 1/3 of the view sits halfway between the movable footer alone and the whole
        // footer: the whole footer is over the threshold, the movable footer is not.
        let overHeight = 3 * (measured.movable + measured.total) / 2
        let over = GDSScreen(viewModel: viewModel)
        layout(over, at: CGSize(width: 390, height: overHeight), contentSize: .large, passes: 3)
        #expect(over.isMovableFooterInScrollView == true)
        #expect(over.bottomStackView.arrangedSubviews.count == 1) // fixed footer stays pinned

        // 1/3 of the view comfortably above the whole footer: nothing moves.
        let underHeight = 3 * measured.total * 1.1
        let under = GDSScreen(viewModel: viewModel)
        layout(under, at: CGSize(width: 390, height: underHeight), contentSize: .large, passes: 3)
        #expect(under.isMovableFooterInScrollView == false)
        #expect(under.bottomStackView.arrangedSubviews.count == 4)
    }

    @Test("""
    The cut-off is a third of the full view height, not of the safe-area container \
    (a large top inset must not make the footer move sooner)
    """)
    func cutOffIsAThirdOfTheFullViewHeight() {
        let viewModel = makeViewModel(movable: 3, fixed: 1)
        let measured = measureFooter(for: viewModel)

        // 1/3 of the view is 10% above the footer, so it fits. The top inset takes 30%
        // of the view, which would put 1/3 of the *container* at 77% of the footer.
        let viewHeight = 3 * measured.total * 1.1
        let topInset = viewHeight * 0.3
        let sut = GDSScreen(viewModel: viewModel)
        layout(
            sut,
            at: CGSize(width: 390, height: viewHeight),
            contentSize: .large,
            additionalSafeArea: UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0),
            passes: 3
        )
        #expect(sut.containerStackView.bounds.height < viewHeight - topInset + 1) // inset applied
        #expect(sut.isMovableFooterInScrollView == false)
    }

    @Test("""
    The production measurement of the footer matches its real laid-out height, including \
    the bottom safe area when a footer background extends under it \
    (regression: the first pass missed the safe-area inset and under-measured by 34pt)
    """)
    func measuredFooterHeightMatchesRealHeight() {
        let bottomInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        let categories: [UIContentSizeCategory] = [.small, .large, .accessibilityLarge]
        for category in categories {
            let sut = GDSScreen(viewModel: makeViewModel(footerBackgroundColor: .systemGray))
            layout(
                sut,
                at: CGSize(width: 390, height: 4000),
                contentSize: category,
                additionalSafeArea: bottomInset,
                passes: 3
            )
            #expect(sut.isMovableFooterInScrollView == false)
            let measured = sut.movableFooterViewsHeight(forWidth: 390) + sut.fixedFooterHeight(forWidth: 390)
            #expect(
                abs(measured - sut.bottomStackView.frame.height) < 1,
                "\(category.rawValue): measured \(measured) vs real \(sut.bottomStackView.frame.height)"
            )
        }
    }

    @Test("""
    Placement does not change between repeated layout passes when the footer is only \
    just over the cut-off, with a bottom safe area (regression: the first pass \
    under-measured the footer, so the decision flipped on the next pass)
    """)
    func placementIsStableAcrossRepeatedLayouts() {
        let bottomInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        let viewModel = makeViewModel(footerBackgroundColor: .systemGray)
        let measured = measureFooter(for: viewModel, additionalSafeArea: bottomInset)

        // The footer is 10pt over the cut-off: within the 34pt the first pass used to miss.
        let viewHeight = 3 * (measured.total - 10)
        let size = CGSize(width: 390, height: viewHeight)

        let sut = GDSScreen(viewModel: viewModel)
        layout(sut, at: size, contentSize: .large, additionalSafeArea: bottomInset, passes: 1)
        let afterOnePass = sut.isMovableFooterInScrollView
        layout(sut, at: size, contentSize: .large, additionalSafeArea: bottomInset, passes: 4)
        let afterFourPasses = sut.isMovableFooterInScrollView

        // Numbers behind the decision, so a failure shows which side is off: the view
        // height the cut-off is derived from, the safe area each side sees, and the
        // measurement against the real footer height from the probe.
        let measuredNow = sut.movableFooterViewsHeight(forWidth: 390) + sut.fixedFooterHeight(forWidth: 390)
        let details = """
        cut-off \(sut.view.bounds.height / 3) (expected \(viewHeight / 3)), \
        measured now \(measuredNow), real footer in probe \(measured.total), \
        view bottom inset \(sut.view.safeAreaInsets.bottom), \
        stack bottom inset \(sut.bottomStackView.safeAreaInsets.bottom), \
        container height \(sut.containerStackView.bounds.height)
        """

        #expect(afterOnePass == afterFourPasses, "one pass: \(afterOnePass), four passes: \(afterFourPasses). \(details)")
        #expect(afterFourPasses == true, "footer did not move. \(details)")
    }
}
