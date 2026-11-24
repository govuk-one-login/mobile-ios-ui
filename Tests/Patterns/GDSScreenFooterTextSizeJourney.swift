@testable import DesignSystem
import SnapshotTesting
import Testing
import UIKit

/// The footer's placement and geometry at one text size, captured so the same size can
/// be compared on the way up and on the way down.
struct FooterSnapshot {
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

/// Steps one `GDSScreen` through a range of Dynamic Type sizes and back, and checks that
/// the footer behaves the same at a given size however it was reached.
///
/// Each step is rendered through the snapshot library, the same path the repo's snapshot
/// tests use to apply Dynamic Type. Overriding the text size by hand (on the window, or on
/// a container) was tried and either had no effect or applied the size late. The
/// comparisons are made between images from this same run, held in memory, so there is
/// no committed reference to go stale between simulator versions.
@MainActor
final class TextSizeJourney: GDSScreenFooterTesting {
    let viewModel: FooterTestViewModel
    let sut: GDSScreen
    let size: CGSize
    let cutOff: CGFloat
    private var previous: FooterSnapshot?

    /// 1/3 of the view sits 50% above the footer at the default size, so the small sizes
    /// are pinned and the largest accessibility size has to move.
    init(viewModel: FooterTestViewModel, defaultFooterHeight: CGFloat) {
        self.viewModel = viewModel
        sut = GDSScreen(viewModel: viewModel)
        size = CGSize(width: 390, height: 3 * defaultFooterHeight * 1.5)
        cutOff = size.height / 3
    }

    // MARK: - Walking the sizes

    /// Steps up through `sizes`. Every change must take effect, and the placement must
    /// match what the real footer height implies.
    func climb(_ sizes: [UIContentSizeCategory]) -> [UIContentSizeCategory: FooterSnapshot] {
        var visited: [UIContentSizeCategory: FooterSnapshot] = [:]
        for category in sizes {
            let snapshot = visit(category, going: "up")
            visited[category] = snapshot
            expectPlacement(of: snapshot, at: category)
        }
        return visited
    }

    /// Steps back down through `sizes`. Every change must take effect, and each size must
    /// match how it looked on the way up. Returns the last step.
    func descend(
        _ sizes: [UIContentSizeCategory],
        comparedWith goingUp: [UIContentSizeCategory: FooterSnapshot]
    ) -> FooterSnapshot? {
        var last: FooterSnapshot?
        for category in sizes {
            let snapshot = visit(category, going: "down")
            last = snapshot
            guard let earlier = goingUp[category] else {
                Issue.record("\(category.rawValue) was not visited on the way up")
                continue
            }
            expectSame(snapshot, as: earlier, at: category)
        }
        return last
    }

    // MARK: - Assertions about the whole journey

    /// Guards the test itself: it really crosses the cut-off, and the footer really grew.
    func expectCrossedTheCutOff(_ smallest: FooterSnapshot?, _ largest: FooterSnapshot?) {
        #expect(smallest?.isInScrollView == false)
        #expect(largest?.isInScrollView == true)
        guard let smallest, let largest else { return }
        #expect(
            (largest.fittedHeights.min() ?? 0) > (smallest.fittedHeights.max() ?? .infinity),
            "text size had no effect on the footer: \(smallest.fittedHeights) at the smallest, \(largest.fittedHeights) at the largest"
        )
    }

    /// Back at the starting size, the footer is exactly where it began.
    func expectBackAtStart(_ start: FooterSnapshot?, last: FooterSnapshot?) {
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 4) // 3 movable + 1 fixed
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only
        guard let start else { return }
        expectFramesMatch(start.movableFrames, sut.movableFooterViews.map(\.frame), "back at the starting size")
        #expect(abs(start.bottomStackHeight - sut.bottomStackView.frame.height) < 0.5)
        // The strongest check: the screen looks exactly as it did at the start.
        expectImagesMatch(start.image, last?.image, "back at the starting size")
    }

    // MARK: - One step

    private func visit(_ category: UIContentSizeCategory, going direction: String) -> FooterSnapshot {
        let snapshot = step(to: category)
        expectFramesAreFresh(snapshot, "\(category.rawValue) going \(direction)")
        if let previous {
            expectImagesDiffer(
                previous.image,
                snapshot.image,
                "\(category.rawValue) going \(direction) differs from the size before"
            )
        }
        previous = snapshot
        return snapshot
    }

    private func step(to category: UIContentSizeCategory) -> FooterSnapshot {
        let image = render(at: category)
        return FooterSnapshot(
            isInScrollView: sut.isMovableFooterInScrollView,
            movableFrames: sut.movableFooterViews.map(\.frame),
            fittedHeights: sut.movableFooterViews.map(fittedHeight),
            measuredFooterHeight: sut.movableFooterViewsHeight(forWidth: size.width)
                + sut.fixedFooterHeight(forWidth: size.width),
            bottomStackHeight: sut.bottomStackView.frame.height,
            image: image
        )
    }

    /// Lays the screen out at `category` and renders it. The library detaches the screen
    /// afterwards; its layout and state stay as they were, so frames can still be read.
    private func render(at category: UIContentSizeCategory) -> UIImage? {
        var image: UIImage?
        Snapshotting<UIViewController, UIImage>
            .image(
                on: ViewImageConfig(safeArea: .zero, size: size),
                traits: UITraitCollection(preferredContentSizeCategory: category)
            )
            .snapshot(sut)
            .run { image = $0 }
        return image
    }

    private func fittedHeight(of view: UIView) -> CGFloat {
        view.systemLayoutSizeFitting(
            CGSize(width: size.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }

    // MARK: - Assertions about one step

    private func expectFramesAreFresh(_ snapshot: FooterSnapshot, _ label: String) {
        for (index, pair) in zip(snapshot.movableFrames, snapshot.fittedHeights).enumerated() {
            let (frame, fitted) = pair
            #expect(
                abs(frame.height - fitted) < 0.5,
                "\(label): view \(index) frame height \(frame.height) but measures \(fitted) (stale frame)"
            )
        }
    }

    private func expectPlacement(of snapshot: FooterSnapshot, at category: UIContentSizeCategory) {
        // Sizes too close to the cut-off to call are only compared up against down.
        let footerHeight = measureFooter(for: viewModel, contentSize: category).total
        guard abs(footerHeight - cutOff) > 4 else { return }
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

    private func expectSame(_ snapshot: FooterSnapshot, as earlier: FooterSnapshot, at category: UIContentSizeCategory) {
        let name = category.rawValue
        #expect(
            snapshot.isInScrollView == earlier.isInScrollView,
            "\(name): in scroll view \(earlier.isInScrollView) going up, \(snapshot.isInScrollView) coming down"
        )
        guard snapshot.isInScrollView == earlier.isInScrollView else { return }
        expectFramesMatch(earlier.movableFrames, snapshot.movableFrames, "\(name) coming down vs going up")
        expectImagesMatch(earlier.image, snapshot.image, "\(name) coming down vs going up")
        #expect(
            abs(earlier.bottomStackHeight - snapshot.bottomStackHeight) < 0.5,
            "\(name): bottom stack \(earlier.bottomStackHeight) going up, \(snapshot.bottomStackHeight) coming down"
        )
    }

    // MARK: - Comparisons

    private func expectFramesMatch(_ lhs: [CGRect], _ rhs: [CGRect], _ message: String) {
        #expect(lhs.count == rhs.count, "\(message): view count differs")
        for (index, pair) in zip(lhs, rhs).enumerated() {
            let (before, after) = pair
            #expect(abs(before.minY - after.minY) < 0.5, "\(message): view \(index) minY \(before.minY) vs \(after.minY)")
            #expect(abs(before.height - after.height) < 0.5, "\(message): view \(index) height \(before.height) vs \(after.height)")
            #expect(abs(before.width - after.width) < 0.5, "\(message): view \(index) width \(before.width) vs \(after.width)")
        }
    }

    /// Asserts two renderings match, using the snapshot library's image diff. On a mismatch
    /// both images are written to the temporary directory and their paths are in the failure.
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
            .appendingPathComponent("GDSScreenFooterTests", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let name = message.replacingOccurrences(of: "[^A-Za-z0-9]+", with: "-", options: .regularExpression)
        let beforeURL = folder.appendingPathComponent("\(name)-before.png")
        let afterURL = folder.appendingPathComponent("\(name)-after.png")
        try? before.pngData()?.write(to: beforeURL)
        try? after.pngData()?.write(to: afterURL)
        Issue.record("\(message): the rendered screen differs (\(difference)). Before: \(beforeURL.path) After: \(afterURL.path)")
    }

    /// Asserts two renderings are not the same: a guard that a change made between them
    /// (here, the text size) really took effect, so the journey can't pass by comparing
    /// screens that never changed.
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
}
