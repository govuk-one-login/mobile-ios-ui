@testable import DesignSystem
import Testing

@MainActor
struct ErrorScreenIconTests {
    @Test("sets correct error icon")
    func usesCorrectErrorIconName() {
        let errorIcon = ErrorScreenIcon.error

        #expect(errorIcon.icon == "exclamationmark.circle")
    }

    @Test("sets correct warning icon")
    func usesCorrectWarningIconName() {
        let errorIcon = ErrorScreenIcon.warning

        #expect(errorIcon.icon == "exclamationmark.circle")
    }

    @Test("sets correct error icon voiceover prefix")
    func errorIconVoiceOverPrefix() {
        let errorIcon = ErrorScreenIcon.error

        #expect(errorIcon.voiceoverPrefix.contains("Error"))
    }

    @Test("sets correct warning icon voiceover prefix")
    func warningIconVoiceOverPrefix() {
        let icon = ErrorScreenIcon.warning

        #expect(icon.voiceoverPrefix.contains("Warning"))
    }
}
