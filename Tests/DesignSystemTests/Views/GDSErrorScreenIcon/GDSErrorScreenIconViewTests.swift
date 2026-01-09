@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct ErrorScreenIconViewTests {

    @Test("sets correct image, layout and accessibility attributes")
    func view_initialisesWithCorrectImage() {
        let view = ErrorScreenIconView(viewModel: .error)

        #expect(view.image != nil)
        #expect(view.image?.renderingMode == .automatic)
        #expect(view.contentMode == .scaleAspectFit)
        #expect(view.tintColor == DesignSystem.Color.Icons.default)
        
        let heightConstraints = view.constraints.filter {
            $0.firstAttribute == .height && $0.constant == 64
        }

        #expect(heightConstraints.count == 1)
        #expect(view.accessibilityIdentifier == "error-screen-icon")
        #expect(view.isAccessibilityElement == true)
        #expect(view.accessibilityLabel == ErrorScreenIcon.error.voiceoverPrefix)
    }

    @Test("set correct accessibility label for the warning icon")
    func correctAccessibilityLabelforWarningIcon() {
        let view = ErrorScreenIconView(viewModel: .warning)

        #expect(view.accessibilityLabel == ErrorScreenIcon.warning.voiceoverPrefix)
    }
}
