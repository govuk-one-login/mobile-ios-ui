@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSButtonStateColorTests {
    
    private func createButton(style: GDSButtonStyle, enabled: Bool = true, highlighted: Bool = false) -> GDSButton {
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "Test"),
            icon: nil,
            style: style,
            buttonAction: .action({})
        )
        let button = GDSButton(viewModel: viewModel)
        button.isEnabled = enabled
        button.isHighlighted = highlighted
        button.general(viewModel: viewModel)
        return button
    }
    
    // MARK: - Disabled state
    
    @Test("Primary button disabled background matches design token")
    func primaryDisabledBackground() {
        let button = createButton(style: .primary, enabled: false)
        #expect(button.configuration?.background.backgroundColor == DesignSystem.Color.Buttons.primaryBackgroundDisabled)
    }
    
    @Test("Primary button disabled foreground matches design token")
    func primaryDisabledForeground() {
        let button = createButton(style: .primary, enabled: false)
        #expect(button.configuration?.baseForegroundColor == DesignSystem.Color.Buttons.primaryForegroundDisabled)
    }
    
    @Test("Destructive button disabled background matches design token")
    func destructiveDisabledBackground() {
        let button = createButton(style: .destructive, enabled: false)
        #expect(button.configuration?.background.backgroundColor == DesignSystem.Color.Buttons.destructiveBackgroundDisabled)
    }
    
    @Test("Destructive button disabled foreground matches design token")
    func destructiveDisabledForeground() {
        let button = createButton(style: .destructive, enabled: false)
        #expect(button.configuration?.baseForegroundColor == DesignSystem.Color.Buttons.destructiveForegroundDisabled)
    }
    
    // MARK: - Highlighted state
    
    @Test("Primary button highlighted background matches design token")
    func primaryHighlightedBackground() {
        let button = createButton(style: .primary, highlighted: true)
        #expect(button.configuration?.background.backgroundColor == DesignSystem.Color.Buttons.primaryBackgroundHighlighted)
    }
    
    @Test("Destructive button highlighted background matches design token")
    func destructiveHighlightedBackground() {
        let button = createButton(style: .destructive, highlighted: true)
        #expect(button.configuration?.background.backgroundColor == DesignSystem.Color.Buttons.destructiveBackgroundHighlighted)
    }
}
