@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSErrorIconTitleTests {
    
    let errorViewModel = GDSErrorIconTitleViewModel(
        icon: .error,
        errorTitle: GDSTextViewModel(
            title: "There is a problem",
            titleFont: DesignSystem.Font.Base.title1Bold,
            alignment: .center,
            accessibilityTraits: .header,
            verticalPadding: .bottom(8)
        )
    )
    
    @Test("sets correct image, layout and accessibility attributes")
    func setsCorrectImageConfiguration() {
        let view = GDSErrorIconTitle(viewModel: errorViewModel)
        
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIImageView
        
        #expect(iconView?.image != nil)
        #expect(iconView?.image?.renderingMode == .automatic)
        #expect(iconView?.contentMode == .scaleAspectFit)
        #expect(iconView?.tintColor == DesignSystem.Color.Icons.default)
        
        let heightConstraints = iconView?.constraints.filter {
            $0.firstAttribute == .height && $0.constant == errorViewModel.renderedIconHeight
        }
        
        #expect(heightConstraints?.count == 1)
        
        // icon accessibility
        #expect(iconView?.accessibilityLabel == nil)
        #expect(iconView?.isAccessibilityElement == false)
        
        // container accessibility
        #expect(stackView?.isAccessibilityElement == true)
        #expect(stackView?.shouldGroupAccessibilityChildren == true)
        #expect(stackView?.accessibilityLabel == "Error: There is a problem")
        #expect(stackView?.accessibilityIdentifier == "error-screen-icon-title-stack-view")
        
        #expect(stackView?.accessibilityTraits.contains(.header) == true)
        
        
    }
    
    @Test("supports custom icon height")
    func supportsCustomHeight() {
        
        let errorViewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            errorTitle: GDSTextViewModel(
                title: "There is a problem",
                accessibilityTraits: .header,
            
            ),
            iconHeight: 48,
        )
        
        let view = GDSErrorIconTitle(viewModel: errorViewModel)
        
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIImageView
        
        let heightConstraints = iconView?.constraints.first {
            $0.firstAttribute == .height
        }
            
        #expect(heightConstraints != nil)
        #expect(heightConstraints?.constant == 48 + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding)
    }
        
    @Test("set correct accessibility label when icon is a warning")
    func correctAccessibilityLabelforWarningIcon() {
        
        let errorViewModel = GDSErrorIconTitleViewModel(
            icon: .warning,
            errorTitle: GDSTextViewModel(
                title: "There is a problem",
                accessibilityTraits: .header,
            
            )
        )
        
        let view = GDSErrorIconTitle(viewModel: errorViewModel)
        
        let stackView = view.subviews.first as? UIStackView
        
        #expect(stackView?.accessibilityLabel == "Warning: There is a problem")
    }
    
}
