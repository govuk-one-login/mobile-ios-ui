@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSStatusOverlayTests {
    let viewModel = GDSStatusOverlayViewModel(
        statusText: GDSTextViewModel(title: "Photo submitted",
                                     titleFont: DesignSystem.Font.Base.bodySemiBold,
                                     textColor: DesignSystem.Color.Text.statusOverlay
        )
    )
    
    @Test("Test configuration used for icon view")
    func setsCorrectIconViewConfiguration() {
        let view = GDSStatusOverlay(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        let iconView = stackView?.arrangedSubviews.first as? UIImageView
        
        #expect(iconView?.image != nil)
        
        #expect(iconView?.tintColor == viewModel.iconStyle?.colour)
        #expect(iconView?.contentMode == .center)
        
        #expect(iconView?.adjustsImageSizeForAccessibilityContentSizeCategory == true)
        #expect(iconView?.isAccessibilityElement == true)
        #expect(iconView?.accessibilityIdentifier == "status-overlay-icon")
        
        #expect(iconView?.accessibilityLabel == nil)
        #expect(iconView?.isAccessibilityElement == true)
    }
    
    @Test("Test configuration used for stack view")
    func setsCorrectStackViewConfiguration() {
        let view = GDSStatusOverlay(viewModel: viewModel)
        let stackView = view.subviews.first as? UIStackView
        
        #expect(stackView?.arrangedSubviews.count == 2)
        #expect(stackView?.axis == .vertical)
        #expect(stackView?.spacing == CGFloat(DesignSystem.Spacing.default))
        
        #expect(stackView?.layer.cornerRadius == DesignSystem.CornerRadius.small)
        #expect(stackView?.layer.masksToBounds == true)
        
        #expect(stackView?.isLayoutMarginsRelativeArrangement == true)
        #expect(stackView?.layoutMargins == UIEdgeInsets(top: 30, left: 8, bottom: 20, right: 8))
        
        #expect(stackView?.isAccessibilityElement == true)
        #expect(stackView?.shouldGroupAccessibilityChildren == true)
        #expect(stackView?.accessibilityLabel == "Success: Photo submitted")
        
        #expect(stackView?.accessibilityTraits.contains(.none) == true)
        #expect(stackView?.accessibilityIdentifier == "status-overlay-stack-view")
    }
    
    @Test("Test configuration used to present status overlay")
    func presentationOfComponent() {
        let statusOverlay = GDSStatusOverlay(viewModel: viewModel)
        let parentView = UIView()
        statusOverlay.present(onView: parentView)
        
        let presentation = parentView.subviews.first
        
        #expect(presentation?.translatesAutoresizingMaskIntoConstraints == false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            #expect(parentView.subviews.first == nil)
            #expect(presentation?.isUserInteractionEnabled == true)
            #expect(presentation?.accessibilityElementsHidden == false)
        }
    }
}
