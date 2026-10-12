@testable import DesignSystem
import Testing
import UIKit

/// Regression tests for the `secondaryOutlined` corner radius.
///
/// The bug: the rounded corner radius was only applied to
/// `configuration.background.cornerRadius`. The border, however, is drawn on the
/// view's own `layer`, whose `cornerRadius` was left at `0`. On iOS 26 the
/// configuration background drives the layer corners so it looked correct, but
/// prior to iOS 26 it does not, so the bordered button rendered with square
/// corners.
///
/// These assertions are OS-version independent: the fix guarantees that *both*
/// the configuration background radius and the layer radius are set to the
/// style's `cornerRadius` whenever a border is present. The `layer.cornerRadius`
/// assertion is the one that fails before the fix and is what the pre-iOS-26
/// rendering actually depends on.
@MainActor
struct GDSButtonCornerRadiusTests {

    private func realisedButton(style: GDSButtonStyle) -> GDSButton {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: style,
            buttonAction: .action({})
        )
        let button = GDSButton(viewModel: viewModel)
        // Normally UIKit invokes this during a configuration update; call it
        // manually so `general()` -> `addBorder()` runs, just like the other
        // GDSButton tests in this target.
        button.configurationUpdateHandler?(button)
        return button
    }

    @Test("secondaryOutlined sets the layer corner radius so the border renders rounded pre-iOS 26")
    func secondaryOutlinedSetsLayerCornerRadius() {
        let sut = realisedButton(style: .secondaryOutlined)

        // This is the assertion that fails before the fix.
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
    }

    @Test("secondaryOutlined also keeps the configuration background corner radius (iOS 26+ path)")
    func secondaryOutlinedSetsConfigurationCornerRadius() {
        let sut = realisedButton(style: .secondaryOutlined)

        #expect(sut.configuration?.background.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
    }

    @Test("secondaryOutlined applies the border width/colour on the layer")
    func secondaryOutlinedAppliesBorder() {
        let sut = realisedButton(style: .secondaryOutlined)

        #expect(sut.layer.borderWidth == 1)
        #expect(sut.clipsToBounds == true)
        #expect(sut.layer.cornerCurve == .continuous)
    }

    @Test("a bordered style keeps its layer and configuration radii in sync")
    func borderedStyleKeepsLayerAndConfigurationRadiiInSync() {
        let sut = realisedButton(style: .secondaryOutlined)

        #expect(sut.layer.cornerRadius == sut.configuration?.background.cornerRadius)
    }

    @Test("a style without a border does not force a layer corner radius")
    func styleWithoutBorderLeavesLayerCornerRadiusUntouched() {
        // `secondary` has a fixed cornerStyle + cornerRadius but no border, so the
        // layer path in `addBorder` must not run; its radius stays at the default 0.
        let sut = realisedButton(style: .secondary)

        #expect(sut.viewModel.style.border == nil)
        #expect(sut.layer.cornerRadius == 0)
        // The configuration still carries the radius for the capsule/fixed rendering.
        #expect(sut.configuration?.background.cornerRadius == CGFloat(DesignSystem.Spacing.xSmall))
    }
}
