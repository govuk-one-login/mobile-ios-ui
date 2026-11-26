@testable import DesignSystem
import Testing
import UIKit

/// A screen view model that can set a footer background colour. Setting one makes the
/// container extend under the bottom safe area, which changes the footer's margin.
struct FooterTestViewModel: GDSScreenViewModel {
    let screenStyle: GDSScreenStyle = .top
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    let footerBackgroundColor: UIColor?
}

/// Set-up shared by the `GDSScreen` footer tests: laying a screen out in a window, and
/// measuring its footer. Conform a test suite to get these as if they were its own.
@MainActor
protocol GDSScreenFooterTesting {}

extension GDSScreenFooterTesting {
    /// Lays the screen out inside a window at `size`, driving the real
    /// `viewDidLayoutSubviews` -> `checkBottomStackHeight()` path (rather than
    /// calling the move functions directly), so the movable-footer placement is
    /// decided against actual frame heights the way it is on device.
    func layout(_ sut: GDSScreen, at size: CGSize) {
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
    func layout(
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

    func makeViewModel(
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
    func measureFooter(
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
}
