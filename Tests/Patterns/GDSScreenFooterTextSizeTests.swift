@testable import DesignSystem
import Testing
import UIKit

/// Dynamic Type behaviour of the footer: sizes really are applied, and the footer behaves
/// the same at a size however it was reached.
@MainActor
struct GDSScreenFooterTextSizeTests: GDSScreenFooterTesting {
    @Test("""
    Stepping Dynamic Type up through a range of sizes and back down changes the screen at \
    every step, gives the same placement and layout at each size on the way down as on \
    the way up, and the original layout once back at the starting size (the result must \
    not depend on the route taken through the sizes)
    """)
    func footerLayoutDoesNotDependOnTheRouteTakenThroughTextSizes() {
        let viewModel = makeViewModel(movable: 3, fixed: 1)
        let journey = TextSizeJourney(
            viewModel: viewModel,
            defaultFooterHeight: measureFooter(for: viewModel, contentSize: .large).total
        )
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

        let goingUp = journey.climb(ascent)
        journey.expectCrossedTheCutOff(
            ascent.first.flatMap { goingUp[$0] },
            ascent.last.flatMap { goingUp[$0] }
        )
        let lastStep = journey.descend(descent, comparedWith: goingUp)
        journey.expectBackAtStart(ascent.first.flatMap { goingUp[$0] }, last: lastStep)
    }
}
