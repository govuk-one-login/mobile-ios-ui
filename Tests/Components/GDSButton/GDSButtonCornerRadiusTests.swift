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
/// The fix sets `layer.cornerRadius` as well, but only on iOS < 26 (guarded by
/// `if #unavailable(iOS 26)` in `addBorder`). On iOS 26+ the configuration
/// background is left to drive the corners, so the layer radius stays at its
/// default `0`. These tests therefore assert version-dependent behaviour:
///   - iOS < 26: `layer.cornerRadius` == style `cornerRadius`
///   - iOS 26+:  `layer.cornerRadius` == 0 (configuration drives the corners)
/// In both cases `configuration.background.cornerRadius` carries the radius.
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

    @Test("secondaryOutlined sets the layer corner radius on iOS < 26 so the border renders rounded")
    func secondaryOutlinedSetsLayerCornerRadiusPreIOS26() {
        let sut = realisedButton(style: .secondaryOutlined)

        if #unavailable(iOS 26) {
            // This is the assertion that fails before the fix on iOS < 26.
            #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
        } else {
            // On iOS 26+ the configuration background drives the corners, so the
            // layer radius is deliberately left untouched.
            #expect(sut.layer.cornerRadius == 0)
        }
    }

    @Test("secondaryOutlined always keeps the configuration background corner radius")
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

    @Test("a bordered style keeps its layer and configuration radii in sync on iOS < 26")
    func borderedStyleKeepsLayerAndConfigurationRadiiInSyncPreIOS26() {
        let sut = realisedButton(style: .secondaryOutlined)

        if #unavailable(iOS 26) {
            #expect(sut.layer.cornerRadius == sut.configuration?.background.cornerRadius)
        } else {
            // iOS 26+: the layer radius is not synced to the configuration; the
            // configuration background drives the rendered corners instead.
            #expect(sut.layer.cornerRadius == 0)
            #expect(sut.configuration?.background.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
        }
    }

    @Test("a style without a border does not force a layer corner radius")
    func styleWithoutBorderLeavesLayerCornerRadiusUntouched() {
        // `secondary` has a fixed cornerStyle + cornerRadius but no border, so the
        // layer path in `addBorder` must not run on any OS; its radius stays at 0.
        let sut = realisedButton(style: .secondary)

        #expect(sut.viewModel.style.border == nil)
        #expect(sut.layer.cornerRadius == 0)
        // The configuration still carries the radius for the capsule/fixed rendering.
        #expect(sut.configuration?.background.cornerRadius == CGFloat(DesignSystem.Spacing.xSmall))
    }

    // MARK: - Direct `addBorder` tests
    //
    // These exercise both `setLayerCornerRadius` states directly, so both
    // branches are covered on *any* OS without depending on the `#unavailable`
    // gate in `general()` that chooses the flag at runtime.

    @Test("addBorder with setLayerCornerRadius=true sets both the layer and configuration radii")
    func addBorderSetsLayerCornerRadiusWhenRequested() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondaryOutlined,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        // Ensure a configuration exists so `background.cornerRadius` persists,
        // then start from a known-clear layer radius.
        sut.configurationUpdateHandler?(sut)
        sut.layer.cornerRadius = 0

        sut.addBorder(viewModel: viewModel, setLayerCornerRadius: true)

        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
        #expect(sut.configuration?.background.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
    }

    @Test("addBorder with setLayerCornerRadius=false leaves the layer radius at 0 but still sets the configuration radius")
    func addBorderLeavesLayerCornerRadiusWhenNotRequested() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondaryOutlined,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        sut.configurationUpdateHandler?(sut)
        sut.layer.cornerRadius = 0

        sut.addBorder(viewModel: viewModel, setLayerCornerRadius: false)

        #expect(sut.layer.cornerRadius == 0)
        #expect(sut.configuration?.background.cornerRadius == DesignSystem.CornerRadius.secondaryOutlinedButton)
    }

    @Test("addBorder always applies the border width/colour and continuous corner curve")
    func addBorderAppliesBorderRegardlessOfLayerCornerRadiusFlag() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondaryOutlined,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        sut.configurationUpdateHandler?(sut)

        sut.addBorder(viewModel: viewModel, setLayerCornerRadius: false)

        #expect(sut.layer.borderWidth == 1)
        #expect(sut.clipsToBounds == true)
        #expect(sut.layer.cornerCurve == .continuous)
    }
}
