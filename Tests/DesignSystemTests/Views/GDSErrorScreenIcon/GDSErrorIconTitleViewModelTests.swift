@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSErrorScreenIconViewModelTests {
    
    let viewModel = GDSErrorIconTitleViewModel(
        icon: .error,
        errorTitle: GDSTextViewModel(
        title: "There is a problem",
        accessibilityTraits: .header
        )
    )
    
    @Test("sets correct error icon")
    func usesCorrectErrorIconName() {
        #expect(viewModel.icon.iconName == "exclamationmark.circle")
    }

    @Test("sets correct warning icon")
    func usesCorrectWarningIconName() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .warning,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: .header
            )
        )

        #expect(viewModel.icon.iconName == "exclamationmark.circle")
    }

    @Test("sets correct error icon voiceover prefix")
    func errorIconVoiceOverPrefix() {
        #expect(viewModel.icon.voiceoverPrefix.contains("Error"))
    }

    @Test("sets correct warning icon voiceover prefix")
    func warningIconVoiceOverPrefix() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .warning,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: .header
            )
        )
        
        #expect(viewModel.icon.voiceoverPrefix.contains("Warning"))
    }
    
    @Test("rendered icon height includes SF Symbol padding")
    func renderedHeightIncludesSFSymbolPadding() {
        #expect(viewModel.renderedIconHeight == DesignSystem.Size.GDSErrorIcon.iconTargetHeight + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding)
    }
    
    @Test("accessibility label combines error prefix and title")
    func accessibilityLabelCombinesPrefixAndTitle() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .warning,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: .header
            )
        )
        
        #expect(viewModel.accessibilityLabel == "Warning: There is a problem")
    }
    
    @Test("voiceover announces header when title explicitly has a header trait")
    func announcesHeaderWhenExplicitlyProvided() {
        
        #expect(viewModel.accessibilityTrait.contains(.header))
    }
    
    @Test("voiceover announces header when title header trait is nil")
    func announcesHeaderWhenHeaderTraitIsNil() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: nil
        
            )
        )
        #expect(viewModel.accessibilityTrait.contains(.header))
    }
    
    @Test("voiceover announces header when title header trait is opted out")
    func suppressesHeaderWhenHeaderIsDisabled() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: [.staticText]
            )
        )
        
        #expect(!viewModel.accessibilityTrait.contains(.header))
    }
}
