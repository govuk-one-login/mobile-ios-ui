@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSWarningTextTests {
    let warningTextViewModel = GDSWarningTextViewModel(
        warningText: GDSTextViewModel(title: "lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                      titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
    
    @Test("Test configuration used for icon view")
    func setsCorrectIconViewConfiguration() {
        let view = GDSWarningText(viewModel: warningTextViewModel)
        
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIImageView
        
        #expect(iconView?.image != nil)
        
        #expect(iconView?.tintColor == DesignSystem.Color.Icons.default)
        #expect(iconView?.contentMode == .topLeft)
        
        #expect(iconView?.adjustsImageSizeForAccessibilityContentSizeCategory == true)
        #expect(iconView?.isAccessibilityElement == true)
        #expect(iconView?.accessibilityIdentifier == "warning-text-icon")
        
        #expect(iconView?.accessibilityLabel == nil)
        #expect(iconView?.isAccessibilityElement == true)
    }
    
    @Test("Test configuration used for stack view")
    func setsCorrectStackViewConfiguration() {
        let view = GDSWarningText(viewModel: warningTextViewModel)
        
        let stackView = view.subviews.first as? UIStackView
        
        #expect(stackView?.arrangedSubviews.count == 2)
        #expect(stackView?.axis == .horizontal)
        #expect(stackView?.spacing == CGFloat(DesignSystem.Spacing.GDSWarningText.default))
        #expect(stackView?.alignment == .fill)
        
        #expect(stackView?.isAccessibilityElement == true)
        #expect(stackView?.shouldGroupAccessibilityChildren == true)
        #expect(stackView?.accessibilityLabel == "Warning: lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        
        #expect(stackView?.accessibilityTraits.contains(.none) == true)
        #expect(stackView?.accessibilityIdentifier == "warning-text-stack-view")
    }
}
