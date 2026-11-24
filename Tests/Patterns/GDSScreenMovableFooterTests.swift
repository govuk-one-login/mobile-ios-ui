@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

/// A screen view model that can set a footer background colour. Setting one makes the
/// container extend under the bottom safe area, which changes the footer's margin.
private struct FooterTestViewModel: GDSScreenViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    let footerBackgroundColor: UIColor?
}

/// Keeps one window alive for a whole journey and resizes it in place, so the screen
/// sees a sequence of size changes the way it would on a device, instead of a clean
/// first layout at every step. Text size is not handled here: see
/// `renderThroughSnapshotLibrary`.
@MainActor
private final class ScreenHost {
    private let window: UIWindow
    private let root = UIViewController()
    private let screen: GDSScreen

    init(screen: GDSScreen) {
        self.screen = screen
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 800))
        window.rootViewController = root
        window.makeKeyAndVisible()

        root.addChild(screen)
        screen.view.frame = root.view.bounds
        screen.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        root.view.addSubview(screen.view)
        screen.didMove(toParent: root)
    }

    /// Resizes the window in place, lays out, and returns a rendering of the screen.
    func show(at size: CGSize, passes: Int = 3) -> UIImage {
        window.frame = CGRect(origin: .zero, size: size)
        root.view.frame = window.bounds
        for _ in 0..<max(passes, 1) {
            screen.view.setNeedsLayout()
            screen.view.layoutIfNeeded()
        }
        return UIGraphicsImageRenderer(bounds: screen.view.bounds).image { _ in
            screen.view.drawHierarchy(in: screen.view.bounds, afterScreenUpdates: true)
        }
    }
}

/// The footer's placement and geometry at one viewport height, captured so the same
/// height can be compared on the way in and on the way back.
private struct FooterSnapshot {
    let isInScrollView: Bool
    let movableFrames: [CGRect]
    /// Each movable view's height measured fresh at the same width, to compare with its
    /// frame: a frame that differs from this is stale (not yet updated for the text size).
    let fittedHeights: [CGFloat]
    /// What the screen itself measured for the whole footer when it made its decision.
    let measuredFooterHeight: CGFloat
    let bottomStackHeight: CGFloat
    /// What the screen actually looks like, so overlap, clipping and spacing are
    /// compared as well as frames.
    let image: UIImage?
}

/// Regression coverage for the movable footer transitioning between the pinned
/// bottom stack and the scroll view. Kept in its own type so the measurement
/// helpers live next to the only tests that use them.
@MainActor
struct GDSScreenMovableFooterTests {
    /// Lays the screen out inside a window at `size`, driving the real
    /// `viewDidLayoutSubviews` -> `checkBottomStackHeight()` path (rather than
    /// calling the move functions directly), so the movable-footer placement is
    /// decided against actual frame heights the way it is on device.
    private func layout(_ sut: GDSScreen, at size: CGSize) {
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.view.frame = window.bounds
        sut.view.setNeedsLayout()
        sut.view.layoutIfNeeded()
    }

    /// Lays the screen out inside a fixed-size window while forcing a Dynamic Type
    /// content size category, driving the real `viewDidLayoutSubviews` ->
    /// `checkBottomStackHeight()` path so the movable-footer placement is decided
    /// against the actual frame heights produced at that text size.
    ///
    /// Uses a parent controller + `setOverrideTraitCollection` rather than
    /// `traitOverrides` (iOS 17+) so it builds against the package's iOS 15 target.
    ///
    /// `additionalSafeArea` simulates device safe-area insets (a test window has none),
    /// and `passes` runs extra layout passes while the window is alive.
    private func layout(
        _ sut: GDSScreen,
        at size: CGSize,
        contentSize: UIContentSizeCategory,
        additionalSafeArea: UIEdgeInsets = .zero,
        passes: Int = 1
    ) {
        let parent = UIViewController()
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = parent
        window.makeKeyAndVisible()

        sut.additionalSafeAreaInsets = additionalSafeArea
        parent.addChild(sut)
        sut.view.frame = parent.view.bounds
        parent.view.addSubview(sut.view)
        parent.setOverrideTraitCollection(
            UITraitCollection(preferredContentSizeCategory: contentSize),
            forChild: sut
        )
        sut.didMove(toParent: parent)

        for _ in 0..<max(passes, 1) {
            sut.view.setNeedsLayout()
            sut.view.layoutIfNeeded()
        }
    }

    private func makeViewModel(
        movable: Int = 3,
        fixed: Int = 1,
        footerBackgroundColor: UIColor? = nil
    ) -> FooterTestViewModel {
        let movableViews: [any ContentViewModel] = (0..<movable).map { index in
            GDSButtonViewModel(title: "Movable \(index)", style: .secondary, buttonAction: .action({}))
        }
        let fixedViews: [any ContentViewModel] = (0..<fixed).map { index in
            GDSButtonViewModel(title: "Fixed \(index)", style: .primary, buttonAction: .action({}))
        }
        return FooterTestViewModel(
            body: [GDSTextViewModel(title: "body")],
            movableFooter: movableViews,
            footer: fixedViews,
            footerBackgroundColor: footerBackgroundColor
        )
    }

    /// The footer's real height, read from a screen laid out in a window so tall that
    /// nothing moves. Independent of the production measurement, so it can act as the
    /// reference the cut-off is compared against.
    private func measureFooter(
        for viewModel: FooterTestViewModel,
        width: CGFloat = 390,
        contentSize: UIContentSizeCategory = .large,
        additionalSafeArea: UIEdgeInsets = .zero
    ) -> (movable: CGFloat, total: CGFloat) {
        let probe = GDSScreen(viewModel: viewModel)
        layout(
            probe,
            at: CGSize(width: width, height: 4000),
            contentSize: contentSize,
            additionalSafeArea: additionalSafeArea,
            passes: 3
        )
        return (
            movable: probe.movableFooterViewsHeight(forWidth: width),
            // The probe window is taller than the screen, so it picks up the device's own
            // bottom inset on top of `additionalSafeArea`, which would inflate the
            // footer's bottom margin compared with the (shorter) windows under test.
            // Take the real content height and rebuild the margin from the inset those
            // windows will have: the base spacing, plus the extra bottom inset when a
            // footer background extends the container under the bottom safe area.
            total: probe.bottomStackView.frame.height
                - probe.bottomStackView.directionalLayoutMargins.bottom
                + DesignSystem.Spacing.default
                + (viewModel.footerBackgroundColor != nil ? additionalSafeArea.bottom : .zero)
        )
    }

    private func expectFramesMatch(_ lhs: [CGRect], _ rhs: [CGRect], _ message: String) {
        #expect(lhs.count == rhs.count, "\(message): view count differs")
        for (index, pair) in zip(lhs, rhs).enumerated() {
            let (before, after) = pair
            #expect(abs(before.minY - after.minY) < 0.5, "\(message): view \(index) minY \(before.minY) vs \(after.minY)")
            #expect(abs(before.height - after.height) < 0.5, "\(message): view \(index) height \(before.height) vs \(after.height)")
            #expect(abs(before.width - after.width) < 0.5, "\(message): view \(index) width \(before.width) vs \(after.width)")
        }
    }

    @Test("""
    Movable footer returns to the bottom stack after a short -> tall layout change \
    (regression: portrait -> landscape -> portrait left it stranded in the scroll view)
    """)
    func movableFooterReturnsToBottomAfterRotation() throws {
        // Several footer items so the footer comfortably exceeds 1/3 of a short
        // (landscape-height) viewport but stays well under 1/3 of a tall
        // (portrait-height) viewport, making the threshold crossing deterministic
        // without depending on exact per-button metrics.
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
        let landscape = CGSize(width: 800, height: 220)

        // Portrait: footer is short relative to the screen, so it stays pinned.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Landscape: footer now exceeds 1/3 of the short viewport, so it is moved
        // into the scroll view to remain reachable.
        layout(sut, at: landscape)
        #expect(sut.isMovableFooterInScrollView == true)
        #expect(sut.bottomStackView.arrangedSubviews.isEmpty)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 4) // body + 3 footer

        // Back to portrait: the footer must return to the pinned bottom stack.
        // Before the fix this reverse transition did not run against the settled
        // portrait geometry, leaving the footer stranded in the scroll view.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
    }

    @Test("""
    Only the movable footer moves into the scroll view; fixed footer content stays \
    pinned in the bottom stack, and both return correctly
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
        let landscape = CGSize(width: 800, height: 220)

        // Portrait: movable + fixed footer content all pinned in the bottom stack.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4) // 3 movable + 1 fixed
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Landscape: only the movable footer moves; the fixed footer stays pinned.
        layout(sut, at: landscape)
        #expect(sut.isMovableFooterInScrollView == true)
        #expect(sut.bottomStackView.arrangedSubviews.count == 1) // fixed footer only
        #expect(sut.bottomStackView.isHidden == false)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 4) // body + 3 movable
        for view in sut.movableFooterViews {
            #expect(view.superview === sut.scrollViewInnerStackView)
        }
        if let fixed = sut.bottomStackView.arrangedSubviews.first {
            #expect(sut.movableFooterViews.contains { $0 === fixed } == false)
        }

        // Back to portrait: movable footer returns above the fixed footer, in order.
        layout(sut, at: portrait)
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

    /// Compares two renderings of the same screen using the snapshot library's image
    /// diff. These are not snapshot tests in the usual sense: both images come from this
    /// same run and are held in memory, so there is no committed reference to go stale
    /// between simulator versions or text-size settings.
    ///
    /// On a mismatch both images are written to the temporary directory, and their
    /// paths are included in the failure so they can be opened side by side.
    private func expectImagesMatch(_ before: UIImage?, _ after: UIImage?, _ message: String) {
        guard let before, let after else {
            Issue.record("\(message): no image was captured")
            return
        }
        guard let (difference, _) = Diffing<UIImage>
            .image(precision: 0.999, perceptualPrecision: 0.99)
            .diff(before, after)
        else { return }

        let folder = FileManager.default.temporaryDirectory
            .appendingPathComponent("GDSScreenMovableFooterTests", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let name = message.replacingOccurrences(of: "[^A-Za-z0-9]+", with: "-", options: .regularExpression)
        let beforeURL = folder.appendingPathComponent("\(name)-before.png")
        let afterURL = folder.appendingPathComponent("\(name)-after.png")
        try? before.pngData()?.write(to: beforeURL)
        try? after.pngData()?.write(to: afterURL)
        Issue.record("\(message): the rendered screen differs (\(difference)). Before: \(beforeURL.path) After: \(afterURL.path)")
    }

    /// Lays the screen out at `contentSize` and renders it through the snapshot library,
    /// the same path the repo's snapshot tests use to apply Dynamic Type. Overriding the
    /// text size by hand (on the window, or on a container) was tried and either had no
    /// effect or applied the size late, so this reuses the library's own set-up, which is
    /// known to produce a different rendering for each size.
    ///
    /// The library detaches the screen afterwards. Its layout and any state it holds stay
    /// as they were when it was rendered, so frames can still be read.
    private func renderThroughSnapshotLibrary(
        _ sut: GDSScreen,
        size: CGSize,
        contentSize: UIContentSizeCategory
    ) -> UIImage? {
        var image: UIImage?
        Snapshotting<UIViewController, UIImage>
            .image(
                on: ViewImageConfig(safeArea: .zero, size: size),
                traits: UITraitCollection(preferredContentSizeCategory: contentSize)
            )
            .snapshot(sut)
            .run { image = $0 }
        return image
    }

    /// Asserts that two renderings are not the same: a guard that a change made between
    /// them (here, the text size) really took effect, so a journey can't pass by
    /// comparing screens that never changed.
    private func expectImagesDiffer(_ before: UIImage?, _ after: UIImage?, _ message: String) {
        guard let before, let after else {
            Issue.record("\(message): no image was captured")
            return
        }
        #expect(
            Diffing<UIImage>.image(precision: 0.999, perceptualPrecision: 0.99).diff(before, after) != nil,
            "\(message): the rendering did not change, so the change was not applied"
        )
    }

    // MARK: - Cut-off and measurement

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

    // MARK: - Route independence

    @Test("""
    Shrinking the screen step by step until the footer moves out, then growing it back, \
    gives the same placement and the same layout at each height on the way back as on \
    the way in, and the original layout once back at the starting height (the result \
    must not depend on the route taken)
    """)
    func footerLayoutDoesNotDependOnTheRouteTakenThroughViewportHeights() {
        let viewModel = makeViewModel(movable: 3, fixed: 1)
        let footerHeight = measureFooter(for: viewModel).total

        // Viewport heights as multiples of the height where 1/3 of the view equals the
        // footer. Above 1 the footer fits; below 1 it is over the cut-off and must move.
        let factors: [CGFloat] = [2.0, 1.5, 1.2, 1.05, 0.95, 0.8, 0.6]
        let backFactors = Array(factors.dropLast().reversed())
        func viewportHeight(_ factor: CGFloat) -> CGFloat { 3 * footerHeight * factor }

        // One screen for the whole journey, so any state carried between sizes counts.
        let sut = GDSScreen(viewModel: viewModel)
        let host = ScreenHost(screen: sut)
        func step(to factor: CGFloat) -> FooterSnapshot {
            let image = host.show(at: CGSize(width: 390, height: viewportHeight(factor)))
            return FooterSnapshot(
                isInScrollView: sut.isMovableFooterInScrollView,
                movableFrames: sut.movableFooterViews.map(\.frame),
                fittedHeights: sut.movableFooterViews.map { view in
                    view.systemLayoutSizeFitting(
                        CGSize(width: 390, height: UIView.layoutFittingCompressedSize.height),
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .fittingSizeLevel
                    ).height
                },
                measuredFooterHeight: sut.movableFooterViewsHeight(forWidth: 390)
                    + sut.fixedFooterHeight(forWidth: 390),
                bottomStackHeight: sut.bottomStackView.frame.height,
                image: image
            )
        }
        func expectFramesAreFresh(_ snapshot: FooterSnapshot, _ label: String) {
            for (index, pair) in zip(snapshot.movableFrames, snapshot.fittedHeights).enumerated() {
                let (frame, fitted) = pair
                #expect(
                    abs(frame.height - fitted) < 0.5,
                    "\(label): view \(index) frame height \(frame.height) but measures \(fitted) (stale frame)"
                )
            }
        }

        // In: at each height the placement matches what the real footer height implies.
        var goingIn: [CGFloat: FooterSnapshot] = [:]
        for factor in factors {
            let snapshot = step(to: factor)
            goingIn[factor] = snapshot
            expectFramesAreFresh(snapshot, "\(factor)x going in")
            #expect(
                snapshot.isInScrollView == (factor < 1),
                "\(factor)x going in: footer \(footerHeight) vs cut-off \(viewportHeight(factor) / 3); the screen measured \(snapshot.measuredFooterHeight)"
            )
        }
        // Guards the test itself: it really crosses the cut-off.
        #expect(goingIn[2.0]?.isInScrollView == false)
        #expect(goingIn[0.6]?.isInScrollView == true)

        // Back: each height must match how it looked on the way in.
        var lastStep: FooterSnapshot?
        for factor in backFactors {
            let snapshot = step(to: factor)
            lastStep = snapshot
            expectFramesAreFresh(snapshot, "\(factor)x coming back")
            guard let earlier = goingIn[factor] else {
                Issue.record("\(factor)x was not visited on the way in")
                continue
            }
            #expect(
                snapshot.isInScrollView == earlier.isInScrollView,
                "\(factor)x: in scroll view \(earlier.isInScrollView) going in, \(snapshot.isInScrollView) coming back"
            )
            guard snapshot.isInScrollView == earlier.isInScrollView else { continue }
            expectFramesMatch(earlier.movableFrames, snapshot.movableFrames, "\(factor)x coming back vs going in")
            expectImagesMatch(earlier.image, snapshot.image, "\(factor)x coming back vs going in")
            #expect(
                abs(earlier.bottomStackHeight - snapshot.bottomStackHeight) < 0.5,
                "\(factor)x: bottom stack \(earlier.bottomStackHeight) going in, \(snapshot.bottomStackHeight) coming back"
            )
        }

        // Back at the starting height: the footer is exactly where it began.
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4) // 3 movable + 1 fixed
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only
        if let start = goingIn[2.0] {
            expectFramesMatch(start.movableFrames, sut.movableFooterViews.map(\.frame), "back at the starting height")
            #expect(abs(start.bottomStackHeight - sut.bottomStackView.frame.height) < 0.5)
            // The strongest check: the screen looks exactly as it did at the start.
            expectImagesMatch(start.image, lastStep?.image, "back at the starting height")
        }
    }

    @Test("""
    Stepping Dynamic Type up through a range of sizes and back down changes the screen at \
    every step, gives the same placement and layout at each size on the way down as on \
    the way up, and the original layout once back at the starting size (the result must \
    not depend on the route taken through the sizes)
    """)
    func footerLayoutDoesNotDependOnTheRouteTakenThroughTextSizes() {
        let viewModel = makeViewModel(movable: 3, fixed: 1)
        let ascent: [UIContentSizeCategory] = [
            .small,
            .large,
            .extraExtraExtraLarge,
            .accessibilityMedium,
            .accessibilityExtraLarge,
            .accessibilityExtraExtraExtraLarge
        ]
        // Everything except the top size, in reverse: ends back at the starting size.
        let descent = Array(ascent.dropLast().reversed())

        // 1/3 of the view sits 50% above the footer at the default size, so the small
        // sizes are pinned and the largest accessibility size has to move.
        let reference = measureFooter(for: viewModel, contentSize: .large)
        let viewHeight = 3 * reference.total * 1.5
        let cutOff = viewHeight / 3
        let size = CGSize(width: 390, height: viewHeight)

        // One screen for the whole journey, so any state carried between sizes counts.
        let sut = GDSScreen(viewModel: viewModel)
        func step(to category: UIContentSizeCategory) -> FooterSnapshot {
            let image = renderThroughSnapshotLibrary(sut, size: size, contentSize: category)
            return FooterSnapshot(
                isInScrollView: sut.isMovableFooterInScrollView,
                movableFrames: sut.movableFooterViews.map(\.frame),
                fittedHeights: sut.movableFooterViews.map { view in
                    view.systemLayoutSizeFitting(
                        CGSize(width: 390, height: UIView.layoutFittingCompressedSize.height),
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .fittingSizeLevel
                    ).height
                },
                measuredFooterHeight: sut.movableFooterViewsHeight(forWidth: 390)
                    + sut.fixedFooterHeight(forWidth: 390),
                bottomStackHeight: sut.bottomStackView.frame.height,
                image: image
            )
        }
        func expectFramesAreFresh(_ snapshot: FooterSnapshot, _ label: String) {
            for (index, pair) in zip(snapshot.movableFrames, snapshot.fittedHeights).enumerated() {
                let (frame, fitted) = pair
                #expect(
                    abs(frame.height - fitted) < 0.5,
                    "\(label): view \(index) frame height \(frame.height) but measures \(fitted) (stale frame)"
                )
            }
        }

        // Up: each change takes effect, and the placement matches the real footer height.
        var goingUp: [UIContentSizeCategory: FooterSnapshot] = [:]
        var previous: FooterSnapshot?
        for category in ascent {
            let snapshot = step(to: category)
            goingUp[category] = snapshot
            expectFramesAreFresh(snapshot, "\(category.rawValue) going up")
            if let previous {
                expectImagesDiffer(previous.image, snapshot.image, "\(category.rawValue) going up differs from the size before")
            }
            previous = snapshot

            // Sizes too close to the cut-off to call are only compared up against down.
            let footerHeight = measureFooter(for: viewModel, contentSize: category).total
            if abs(footerHeight - cutOff) > 4 {
                #expect(
                    snapshot.isInScrollView == (footerHeight > cutOff),
                    """
                    \(category.rawValue) going up: probe footer \(footerHeight) vs cut-off \(cutOff); \
                    the screen measured \(snapshot.measuredFooterHeight), movable view heights \
                    \(snapshot.movableFrames.map(\.height)), fitted \(snapshot.fittedHeights), \
                    bottom stack \(snapshot.bottomStackHeight)
                    """
                )
            }
        }
        // Guards the test itself: it really crosses the cut-off, and the footer really grew.
        #expect(goingUp[.small]?.isInScrollView == false)
        #expect(goingUp[.accessibilityExtraExtraExtraLarge]?.isInScrollView == true)
        if let smallest = goingUp[.small], let largest = goingUp[.accessibilityExtraExtraExtraLarge] {
            #expect(
                (largest.fittedHeights.min() ?? 0) > (smallest.fittedHeights.max() ?? .infinity),
                "text size had no effect on the footer: \(smallest.fittedHeights) at the smallest, \(largest.fittedHeights) at the largest"
            )
        }

        // Down: each change takes effect, and each size matches how it looked going up.
        var lastStep: FooterSnapshot?
        for category in descent {
            let snapshot = step(to: category)
            expectFramesAreFresh(snapshot, "\(category.rawValue) going down")
            expectImagesDiffer(previous?.image, snapshot.image, "\(category.rawValue) going down differs from the size before")
            previous = snapshot
            lastStep = snapshot
            guard let earlier = goingUp[category] else {
                Issue.record("\(category.rawValue) was not visited on the way up")
                continue
            }
            #expect(
                snapshot.isInScrollView == earlier.isInScrollView,
                "\(category.rawValue): in scroll view \(earlier.isInScrollView) going up, \(snapshot.isInScrollView) coming down"
            )
            guard snapshot.isInScrollView == earlier.isInScrollView else { continue }
            expectFramesMatch(earlier.movableFrames, snapshot.movableFrames, "\(category.rawValue) coming down vs going up")
            expectImagesMatch(earlier.image, snapshot.image, "\(category.rawValue) coming down vs going up")
            #expect(
                abs(earlier.bottomStackHeight - snapshot.bottomStackHeight) < 0.5,
                "\(category.rawValue): bottom stack \(earlier.bottomStackHeight) going up, \(snapshot.bottomStackHeight) coming down"
            )
        }

        // Back at the starting size: the footer is exactly where it began.
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4) // 3 movable + 1 fixed
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only
        if let start = goingUp[.small] {
            expectFramesMatch(start.movableFrames, sut.movableFooterViews.map(\.frame), "back at the starting size")
            #expect(abs(start.bottomStackHeight - sut.bottomStackView.frame.height) < 0.5)
            // The strongest check: the screen looks exactly as it did at the start.
            expectImagesMatch(start.image, lastStep?.image, "back at the starting size")
        }
    }
}
