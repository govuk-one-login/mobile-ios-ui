@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSErrorScreenIconTests {

    @Test("sets correct image, layout and accessibility attributes")
    func setsCorrectImageConfiguration() {
        let errorIconViewModel = GDSErrorScreenIconViewModel(icon: .error)
        let view = GDSErrorScreenIcon(viewModel: errorIconViewModel)

        #expect(view.image != nil)
        #expect(view.image?.renderingMode == .automatic)
        #expect(view.contentMode == .scaleAspectFit)
        #expect(view.tintColor == DesignSystem.Color.Icons.default)
        
        let heightConstraints = view.constraints.filter {
            $0.firstAttribute == .height && $0.constant == errorIconViewModel.renderedIconHeight
        }

        #expect(heightConstraints.count == 1)
        #expect(view.accessibilityIdentifier == "error-screen-icon")
        #expect(view.isAccessibilityElement == true)
        #expect(view.accessibilityLabel == ErrorScreenIcon.error.voiceoverPrefix)
    }
    @Test("supports custom icon height")
    func supportsCustomHeight() {
        let errorIconViewModel = GDSErrorScreenIconViewModel(
            icon: .error,
            iconHeight: 48
        )
        
        let view = GDSErrorScreenIcon(viewModel: errorIconViewModel)
        
        let heightConstraints = view.constraints.first {
            $0.firstAttribute == .height
        }
        
        #expect(heightConstraints != nil)
        #expect(heightConstraints?.constant == 48 + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding)
    }

    @Test("set correct accessibility label for the warning icon")
    func correctAccessibilityLabelforWarningIcon() {
        let errorIconViewModel = GDSErrorScreenIconViewModel(icon: .warning)
        let view = GDSErrorScreenIcon(viewModel: errorIconViewModel)

        #expect(view.accessibilityLabel == ErrorScreenIcon.warning.voiceoverPrefix)
    }
}
