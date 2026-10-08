@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
extension GDSButtonTests {
    @Test("Button Shapes enabled then background colour should be systemGray6")
    func buttonShapesEnabledClear_setsSystemGray6() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        
        sut.buttonShapesEnabled(true, viewModel: viewModel)
        #expect(sut.configuration?.baseBackgroundColor?.lightColor == DesignSystem.Color.Base.grey4)
        #expect(sut.configuration?.baseBackgroundColor?.darkColor == DesignSystem.Color.Base.charcoal2)
    }
    
    @Test("Button Shapes is disabled & background colour is clear should default to normal state")
    func buttonShapesDisabled_defaultsToNormal() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        
        sut.buttonShapesEnabled(false, viewModel: viewModel)
        #expect(sut.configuration?.baseBackgroundColor == viewModel.style.backgroundColor.forState(.normal))
    }
    
    
    @Test("Button Shapes is enabled and color is SystemBackground then background colour should be systemGray6")
    func buttonShapesEnabledSytemBackground_setsSystemGray6() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary.adjusting(
                backgroundColor: ColorForState(
                    normal: DesignSystem.Color.Base.background,
                    focused: nil
                )
            ),
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        
        sut.buttonShapesEnabled(true, viewModel: viewModel)
        #expect(sut.configuration?.baseBackgroundColor?.lightColor == DesignSystem.Color.Base.grey4)
        #expect(sut.configuration?.baseBackgroundColor?.darkColor == DesignSystem.Color.Base.charcoal2)
    }
    
    @Test("Button Shapes is disabled & colour is systemBackground should default to normal state")
    func buttonShapesDisabledSystemBackGround_defaultsToNormal() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary.adjusting(
                backgroundColor: ColorForState(
                    normal: DesignSystem.Color.Base.background,
                    focused: nil
                )
            ),
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        
        sut.buttonShapesEnabled(false, viewModel: viewModel)
        #expect(sut.configuration?.baseBackgroundColor == viewModel.style.backgroundColor.forState(.normal))
    }
    
    @Test("Button has custom accessibility Hint")
    func buttonCustomAccessibilityHint() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({}),
            accessibilityHint: "custom hint"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        #expect(sut.accessibilityHint == "custom hint")
    }
    
    @Test("Button has custom accessibility label")
    func buttonCustomAccessibilityLabel() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({}),
            accessibilityLabel: "custom label"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)

        #expect(sut.accessibilityLabel == "custom label")
    }

    @Test("Accessibility hint is applied when no label is provided")
    func buttonAccessibilityHintWithoutLabel() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({}),
            accessibilityHint: "custom hint"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)

        #expect(sut.accessibilityLabel == nil)
        #expect(sut.accessibilityHint == "custom hint")
    }

    @Test("No accessibility label leaves the computed label unset")
    func buttonNoAccessibilityLabel() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)

        #expect(sut.accessibilityLabel == nil)
    }

    @Test("Custom accessibility label is applied via the TitleForState initialiser")
    func buttonCustomAccessibilityLabelTitleForStateInit() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .secondary,
            buttonAction: .action({}),
            accessibilityHint: "custom hint",
            accessibilityLabel: "custom label"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)

        #expect(sut.accessibilityLabel == "custom label")
    }

    @Test("Icon accessibility hint still applies after a custom label is set")
    func buttonAccessibilityLabelWithIconHint() {
        // The icon's accessibility hint is applied after the label block in
        // `buttonUpdater`, so an icon that carries a hint re-populates the hint
        // even when a custom label is present. This test documents that order.
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: IconForState(normal: .xMark),
            style: .secondary,
            buttonAction: .action({}),
            accessibilityLabel: "custom label"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)

        #expect(sut.accessibilityLabel == "custom label")
        #expect(sut.accessibilityHint == "close")
    }

    @Test("Custom accessibility label is ignored while the button is loading")
    func buttonAccessibilityLabelIgnoredWhileLoading() async throws {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .asyncAction(
                {
                    try? await Task.sleep(seconds: 0.3)
                }
            ),
            accessibilityHint: "custom hint",
            accessibilityLabel: "custom label"
        )
        let sut = GDSButton(viewModel: viewModel)

        sut.sendActions(for: .touchUpInside)
        try await Task.sleep(seconds: 0.1)

        #expect(sut.isLoading)
        // While loading the button reports a "Loading" label
        // The handler is normally invoked by UIKit so we call it manually here.
        sut.configurationUpdateHandler?(sut)
        #expect(sut.accessibilityLabel == "Loading")

        await sut.asyncTask?.value
        sut.configurationUpdateHandler?(sut)
        #expect(sut.accessibilityLabel == "custom label")
    }

    @Test("Button has custom accessibility identifier")
    func buttonCustomAccessibilityIdentifier() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondary,
            buttonAction: .action({}),
            accessibilityIdentifier: "any identifier"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        #expect(sut.accessibilityIdentifier == "any identifier")
   }
    
    @Test("Button with border set, corner radius is correct")
    func buttonCustomBorderStyleCornerRadius() {
        let secondaryWithBorderStyle = GDSButtonStyle(
            font: DesignSystem.Font.Base.body,
            alignment: .center,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.small,
                trailing: DesignSystem.Spacing.default
            ),
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.secondaryForeground,
                highlighted: DesignSystem.Color.Buttons.secondaryForegroundHighlighted,
                focused: DesignSystem.Color.Buttons.secondaryForegroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                focused: DesignSystem.Color.Buttons.secondaryBackgroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryBackgroundFocusedHighlighted
            ),
            cornerStyle: .fixed,
            cornerRadius: DesignSystem.Spacing.xSmall,
            border: BorderStyle(width: 4, color: DesignSystem.Color.Buttons.primaryBackground)
        )
        
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: secondaryWithBorderStyle,
            buttonAction: .action({}),
            accessibilityIdentifier: "any identifier"
        )
        let sut = GDSButton(viewModel: viewModel)
        // normally gets invoked by UIKit so we need to call manually here
        sut.configurationUpdateHandler?(sut)
        
        #expect(sut.configuration?.background.cornerRadius == DesignSystem.CornerRadius.xSmall)
   }

    @Test("secondaryOutline button shows focused background when VoiceOver focuses it")
    func secondaryOutlineVoiceOverFocusBackground() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondaryOutlined,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        sut.configurationUpdateHandler?(sut)

        sut.accessibilityElementDidBecomeFocused()

        let focused = DesignSystem.Color.Buttons.secondaryBackgroundFocused
        let focusedForeground = DesignSystem.Color.Buttons.secondaryForegroundFocused
        // Both must reflect the focused colour, since `background.backgroundColor`
        // takes precedence over `baseBackgroundColor` when set (outline style).
        #expect(sut.configuration?.baseBackgroundColor == focused)
        #expect(sut.configuration?.background.backgroundColor == focused)
        // The title colour comes from `attributedTitle`, which overrides `baseForegroundColor`.
        #expect(sut.configuration?.baseForegroundColor == focusedForeground)
        #expect(titleForegroundColor(sut) == focusedForeground)
        #expect(sut.isVoiceOverFocussed == true)
    }

    @Test("secondaryOutline button resets background when VoiceOver focus is lost")
    func secondaryOutlineVoiceOverLoseFocusBackground() {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            icon: nil,
            style: .secondaryOutlined,
            buttonAction: .action({})
        )
        let sut = GDSButton(viewModel: viewModel)
        sut.configurationUpdateHandler?(sut)

        sut.accessibilityElementDidBecomeFocused()
        sut.accessibilityElementDidLoseFocus()
        sut.configurationUpdateHandler?(sut)

        let normal = DesignSystem.Color.Buttons.secondaryOutlinedBackground
        let normalForeground = DesignSystem.Color.Buttons.secondaryForeground
        #expect(sut.configuration?.background.backgroundColor == normal)
        #expect(titleForegroundColor(sut) == normalForeground)
        #expect(sut.isVoiceOverFocussed == false)
    }

    /// Reads the title's foreground colour via the `NSAttributedString` bridge.
    /// Reading `AttributedString.foregroundColor` directly and comparing it goes through an
    /// `AnyHashable` equality path that can crash for dynamic `UIColor`s on some SDKs.
    private func titleForegroundColor(_ button: GDSButton) -> UIColor? {
        guard let attributedTitle = button.configuration?.attributedTitle else { return nil }
        let nsString = NSAttributedString(attributedTitle)
        guard nsString.length > 0 else { return nil }
        return nsString.attribute(
            .foregroundColor,
            at: 0,
            effectiveRange: nil
        ) as? UIColor
    }
}
