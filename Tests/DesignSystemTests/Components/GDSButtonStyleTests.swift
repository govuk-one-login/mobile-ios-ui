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
                normal: .systemBackground,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.primaryBackground,
                focused: DesignSystem.Color.Base.yellow1
            ),
            cornerRadius: DesignSystem.Spacing.default,
            border: nil
        )
        
        #expect(expectation == .primary)
    }
    
    @Test
    func destructive() {
        let expectation = GDSButtonStyle.primary.adjusting(
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Base.red1,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow1
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
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow1
            ),
            cornerRadius: DesignSystem.Spacing.xSmall,
            border: nil
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
