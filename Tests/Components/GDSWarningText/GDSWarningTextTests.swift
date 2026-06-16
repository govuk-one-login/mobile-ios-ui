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
    
    @Test("Test icon colour uses IconStyle colour when provided")
    func setsCustomIconColour() {
        let customColour = UIColor.systemRed
        let viewModel = GDSWarningTextViewModel(
            iconStyle: IconStyle(icon: "exclamationmark.circle.fill", colour: customColour, position: .leading),
            warningText: GDSTextViewModel(title: "Warning", titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
        let view = GDSWarningText(viewModel: viewModel)
        
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIImageView
        
        #expect(iconView?.tintColor == customColour)
    }
    
    @Test("Test custom iconSpacing is applied to stack view")
    func setsCustomIconSpacing() {
        let viewModel = GDSWarningTextViewModel(
            warningText: GDSTextViewModel(title: "Warning", titleFont: DesignSystem.Font.Base.calloutSemiBold),
            iconSpacing: 24
        )
        let view = GDSWarningText(viewModel: viewModel)
        
        let stackView = view.subviews.first as? UIStackView
        
        #expect(stackView?.spacing == 24)
    }
    
    @Test("Test default iconSpacing uses DesignSystem.Spacing.default")
    func setsDefaultIconSpacing() {
        let viewModel = GDSWarningTextViewModel(
            warningText: GDSTextViewModel(title: "Warning", titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
        
        #expect(viewModel.iconSpacing == CGFloat(DesignSystem.Spacing.GDSWarningText.default))
    }
    
    @Test("Test accessibilityLabel uses default warning prefix when iconStyle has no accessibilityHint")
    func accessibilityLabelDefaultPrefix() {
        let viewModel = GDSWarningTextViewModel(
            warningText: GDSTextViewModel(title: "Something went wrong", titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
        
        #expect(viewModel.accessibilityLabel == "Warning: Something went wrong")
    }
    
    @Test("Test accessibilityLabel uses custom accessibilityHint from iconStyle")
    func accessibilityLabelCustomHint() {
        let viewModel = GDSWarningTextViewModel(
            iconStyle: IconStyle(icon: "info.circle", position: .leading, accessibilityHint: "Important"),
            warningText: GDSTextViewModel(title: "Check your details", titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
        
        #expect(viewModel.accessibilityLabel == "Important: Check your details")
    }
    
    @Test("Test accessibilityLabel uses default warning prefix when iconStyle is nil")
    func accessibilityLabelNilIconStyle() {
        let viewModel = GDSWarningTextViewModel(
            iconStyle: nil,
            warningText: GDSTextViewModel(title: "Please try again", titleFont: DesignSystem.Font.Base.calloutSemiBold)
        )
        
        #expect(viewModel.accessibilityLabel == "Warning: Please try again")
    }
    
    @Test("WarningText has custom accessibility identifier")
    func customAccessibilityIdentifier() {
        let viewModel = GDSWarningTextViewModel(
            warningText: GDSTextViewModel(title: "Warning", titleFont: DesignSystem.Font.Base.calloutSemiBold),
            accessibilityIdentifier: "custom-warning"
        )
        let view = GDSWarningText(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        #expect(stackView?.accessibilityIdentifier == "custom-warning")
    }
    
    @Test("WarningText has custom accessibility traits")
    func customAccessibilityTraits() {
        let viewModel = GDSWarningTextViewModel(
            warningText: GDSTextViewModel(title: "Warning", titleFont: DesignSystem.Font.Base.calloutSemiBold),
            accessibilityTraits: .header
        )
        let view = GDSWarningText(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        #expect(stackView?.accessibilityTraits == .header)
    }
}
