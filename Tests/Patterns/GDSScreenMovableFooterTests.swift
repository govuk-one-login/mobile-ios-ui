@testable import DesignSystem
import Testing
import UIKit

/// Regression coverage for the movable footer transitioning between the pinned
/// bottom stack and the scroll view.
@MainActor
struct GDSScreenMovableFooterTests: GDSScreenFooterTesting {
    @Test("""
    Movable footer returns to the bottom stack after a rotation into the split layout and \
    back (regression: portrait -> landscape -> portrait left it stranded in the scroll view)
    """)
    func movableFooterReturnsToBottomAfterRotation() throws {
        // Several footer items, so the movable footer is clearly more than one view.
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "body")],
            movableFooter: [
                GDSButtonViewModel(title: "One", style: .primary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Two", style: .secondary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Three", style: .secondary, buttonAction: .action({}))
            ],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        let portrait = CGSize(width: 390, height: 800)
        // Wider than tall, so the screen uses the split layout.
        let landscape = CGSize(width: 800, height: 220)

        // Portrait: footer is short relative to the screen, so it stays pinned.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Landscape: the screen splits. The movable footer sits in the trailing half, in
        // its own scroll view, and never moves into the body's scroll view.
        layout(sut, at: landscape)
        #expect(sut.isInSplitLayout == true)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.isEmpty)
        #expect(sut.splitMovableStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Back to portrait: the footer must return to the pinned bottom stack.
        layout(sut, at: portrait)
        #expect(sut.isInSplitLayout == false)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.splitMovableStackView.arrangedSubviews.isEmpty)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
    }

    @Test("""
    Only the movable footer moves in the split layout (into the trailing half's scroll \
    view); fixed footer content stays pinned in the bottom stack, and both return correctly
    """)
    func onlyMovableFooterMovesWhenFooterContentPresent() throws {
        let movable = [
            GDSButtonViewModel(title: "One", style: .primary, buttonAction: .action({})),
            GDSButtonViewModel(title: "Two", style: .secondary, buttonAction: .action({})),
            GDSButtonViewModel(title: "Three", style: .secondary, buttonAction: .action({}))
        ]
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "body")],
            movableFooter: movable,
            footer: [GDSTextViewModel(title: "fixed footer")]
        )
        let sut = GDSScreen(viewModel: viewModel)

        let portrait = CGSize(width: 390, height: 800)
        // Wider than tall, so the screen uses the split layout.
        let landscape = CGSize(width: 800, height: 220)

        // Portrait: movable + fixed footer content all pinned in the bottom stack.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4) // 3 movable + 1 fixed
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Landscape: only the movable footer moves, into the trailing half's scroll view;
        // the fixed footer stays pinned beneath it.
        layout(sut, at: landscape)
        #expect(sut.isInSplitLayout == true)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 1) // fixed footer only
        #expect(sut.bottomStackView.isHidden == false)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only
        for view in sut.movableFooterViews {
            #expect(view.superview === sut.splitMovableStackView)
        }
        if let fixed = sut.bottomStackView.arrangedSubviews.first {
            #expect(sut.movableFooterViews.contains { $0 === fixed } == false)
        }

        // Back to portrait: movable footer returns above the fixed footer, in order.
        layout(sut, at: portrait)
        #expect(sut.isInSplitLayout == false)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
        let bottomViews = sut.bottomStackView.arrangedSubviews
        #expect(Array(bottomViews.prefix(3)) == sut.movableFooterViews)
    }

    @Test("""
    Movable footer returns to the bottom stack after Dynamic Type grows past the \
    threshold then shrinks again (regression: large -> small text left it stranded \
    in the scroll view)
    """)
    func movableFooterReturnsToBottomAfterTextShrink() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "body")],
            movableFooter: [
                GDSButtonViewModel(title: "One", style: .primary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Two", style: .secondary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Three", style: .secondary, buttonAction: .action({}))
            ],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        // A viewport short enough that the largest accessibility text pushes the
        // footer past 1/3 of the screen, but tall enough that at small text the
        // footer sits comfortably below the threshold. This keeps the Dynamic Type
        // threshold crossing (not the exact viewport height) the thing under test.
        let viewport = CGSize(width: 390, height: 640)

        // Small text: the footer stays comfortably under 1/3 of the screen, pinned.
        layout(sut, at: viewport, contentSize: .small)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Largest accessibility text: the footer now exceeds 1/3 of the screen and
        // is moved into the scroll view so it remains reachable.
        layout(sut, at: viewport, contentSize: .accessibilityExtraExtraExtraLarge)
        #expect(sut.isMovableFooterInScrollView == true)
        #expect(sut.bottomStackView.arrangedSubviews.isEmpty)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 4) // body + 3 footer

        // Back to small text: the footer must return to the pinned bottom stack.
        // Before the fix the reverse check measured the footer in its scroll-view
        // layout context (and against unsettled frames), so it never fell back
        // below the threshold and the footer stayed stranded in the scroll view.
        layout(sut, at: viewport, contentSize: .small)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
    }
}
