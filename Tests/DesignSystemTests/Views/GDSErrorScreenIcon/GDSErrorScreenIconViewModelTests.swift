@testable import DesignSystem
import Testing

@MainActor
struct GDSErrorScreenIconViewModelTests {
    @Test("sets correct error icon")
    func usesCorrectErrorIconName() {
        let errorIcon = GDSErrorScreenIconViewModel(icon: .error)

        #expect(errorIcon.icon.iconName == "exclamationmark.circle")
    }

    @Test("sets correct warning icon")
    func usesCorrectWarningIconName() {
        let errorIcon = GDSErrorScreenIconViewModel(icon: .warning)

        #expect(errorIcon.icon.iconName == "exclamationmark.circle")
    }

    @Test("sets correct error icon voiceover prefix")
    func errorIconVoiceOverPrefix() {
        let errorIcon = GDSErrorScreenIconViewModel(icon: .error)

        #expect(errorIcon.icon.voiceoverPrefix.contains("Error"))
    }

    @Test("sets correct warning icon voiceover prefix")
    func warningIconVoiceOverPrefix() {
        let errorIcon = GDSErrorScreenIconViewModel(icon: .warning)

        #expect(errorIcon.icon.voiceoverPrefix.contains("Warning"))
    }
}
