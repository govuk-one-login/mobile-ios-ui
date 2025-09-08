@_spi(unstable) import DesignSystem
import Testing
import UIKit

struct GDSButtonStyleTests {
    
    @Test
    func primary() {
        let expectation = GDSButtonStyle(
            font: DesignSystem.Font.Base.bodySemiBold,
            alignment: .center,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.small,
                trailing: DesignSystem.Spacing.default
            ),
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.primaryForeground,
                focused: DesignSystem.Color.Buttons.primaryForegroundFocused,
                disabled: DesignSystem.Color.Buttons.primaryForegroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.primaryForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.primaryBackground,
                highlighted: DesignSystem.Color.Buttons.primaryBackgroundHighlighted,
                focused: DesignSystem.Color.Buttons.primaryBackgroundFocused,
                disabled: DesignSystem.Color.Buttons.primaryBackgroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.primaryBackgroundFocusedHighlighted
            ),
            cornerRadius: DesignSystem.CornerRadius.primaryButton,
            border: nil
        )
        
        #expect(expectation == .primary)
    }
    
    @Test
    func destructive() {
        let expectation = GDSButtonStyle.primary.adjusting(
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.destructiveForeground,
                focused: DesignSystem.Color.Buttons.destructiveForegroundFocused,
                disabled: DesignSystem.Color.Buttons.destructiveForegroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.destructiveForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.destructiveBackground,
                highlighted: DesignSystem.Color.Buttons.destructiveBackgroundHighlighted,
                focused: DesignSystem.Color.Buttons.destructiveBackgroundFocused,
                disabled: DesignSystem.Color.Buttons.destructiveBackgroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.destructiveBackgroundFocusedHighlighted
            )
        )
        
        #expect(expectation == .destructive)
    }
    
    @Test
    func secondary() {
        let expectation = GDSButtonStyle(
            font: DesignSystem.Font.Base.body,
            alignment: .center,
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.secondaryForeground,
                highlighted: DesignSystem.Color.Buttons.secondaryForegroundHighlighted,
                focused: DesignSystem.Color.Buttons.secondaryForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                focused: DesignSystem.Color.Buttons.secondaryBackgroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryBackgroundFocusedHighlighted
            ),
            cornerRadius: DesignSystem.Spacing.xSmall
        )
        
        #expect(expectation == .secondary)
    }
    
    @Test
    func secondaryLeading() {
        let expectation = GDSButtonStyle.secondary.adjusting(
            alignment: .leading,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: 0,
                bottom: DesignSystem.Spacing.small,
                trailing: 0
            )
        )
        
        #expect(expectation == .secondaryLeading)
    }
    
    @Test
    func secondaryLeadingSmall() {
        let expectation = GDSButtonStyle.secondaryLeading.adjusting(
            font: DesignSystem.Font.Base.footnote
        )
        
        #expect(expectation == .secondaryLeadingSmall)
    }
    
    @Test
    func testNewStyle() {
        let expectation = GDSButtonStyle(
            font: DesignSystem.Font.Base.title1,
            alignment: .trailing,
            foregroundColor: ColorForState(
                normal: .systemBackground,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Base.green2,
                focused: DesignSystem.Color.Base.yellow1
            ),
            cornerRadius: DesignSystem.Spacing.default,
            border: BorderStyle(width: 1, color: .red)
        )
        
        #expect(expectation.font == UIFont(.title1))
        #expect(expectation.border == BorderStyle(width: 1, color: .red))
    }
}

extension GDSButtonStyle {
    static var secondaryLeading: Self {
        secondary.adjusting(
            alignment: .leading,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: 0,
                bottom: DesignSystem.Spacing.small,
                trailing: 0
            )
        )
    }
}

extension GDSButtonStyle {
    static var secondaryLeadingSmall: Self {
        secondaryLeading.adjusting(
            font: DesignSystem.Font.Base.footnote
        )
    }
}
