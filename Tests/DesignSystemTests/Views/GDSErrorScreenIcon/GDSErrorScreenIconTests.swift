@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSErrorScreenIconTests {

    @Test("sets correct image, layout and accessibility attributes")
    func view_initialisesWithCorrectImage() {
        let errorIconViewModel = GDSErrorScreenIconViewModel(icon: .error)
        let view = GDSErrorScreenIcon(viewModel: errorIconViewModel)

        #expect(view.image != nil)
        #expect(view.image?.renderingMode == .automatic)
        #expect(view.contentMode == .scaleAspectFit)
        #expect(view.tintColor == DesignSystem.Color.Icons.default)
        
        let heightConstraints = view.constraints.filter {
            $0.firstAttribute == .height && $0.constant == 107
        }

        #expect(heightConstraints.count == 1)
        #expect(view.accessibilityIdentifier == "error-screen-icon")
        #expect(view.isAccessibilityElement == true)
        #expect(view.accessibilityLabel == ErrorScreenIcon.error.voiceoverPrefix)
    }

    @Test("set correct accessibility label for the warning icon")
    func correctAccessibilityLabelforWarningIcon() {
        let errorIconViewModel = GDSErrorScreenIconViewModel(icon: .warning)
        let view = GDSErrorScreenIcon(viewModel: errorIconViewModel)

        #expect(view.accessibilityLabel == ErrorScreenIcon.warning.voiceoverPrefix)
    }
}
