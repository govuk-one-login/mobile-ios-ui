@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSErrorIconViewModelTests {
    
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

    @Test("sets correct update icon")
    func usesCorrectUpdateIconName() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .update,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: .header
            )
        )

        #expect(viewModel.icon.iconName == "exclamationmark.arrow.circlepath")
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
    
    @Test("sets correct update icon voiceover prefix")
    func updateIconVoiceOverPrefix() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .update,
            errorTitle: GDSTextViewModel(
            title: "There is a problem",
            accessibilityTraits: .header
            )
        )
        
        #expect(viewModel.icon.voiceoverPrefix.contains("Error"))
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
    
    // MARK: - Padding
    
    @Test("designated init exposes custom padding on the view model")
    func designatedInitExposesCustomPadding() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            errorTitle: GDSTextViewModel(title: "There is a problem"),
            verticalPadding: .top(4),
            horizontalPadding: .trailing(12)
        )
        
        #expect(viewModel.verticalPadding?.topPadding == 4)
        #expect(viewModel.verticalPadding?.bottomPadding == 0)
        #expect(viewModel.horizontalPadding?.leadingPadding == 0)
        #expect(viewModel.horizontalPadding?.trailingPadding == 12)
    }
    
    @Test("convenience init exposes custom padding on the view model")
    func convenienceInitExposesCustomPadding() {
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            title: "There is a problem",
            verticalPadding: .bottom(6),
            horizontalPadding: .leading(10)
        )
        
        #expect(viewModel.verticalPadding?.topPadding == 0)
        #expect(viewModel.verticalPadding?.bottomPadding == 6)
        #expect(viewModel.horizontalPadding?.leadingPadding == 10)
        #expect(viewModel.horizontalPadding?.trailingPadding == 0)
    }
    
    @Test("designated init keeps default padding")
    func designatedInitKeepsDefaultPadding() {
        let spacing = CGFloat(DesignSystem.Spacing.default)
        
        #expect(viewModel.verticalPadding?.topPadding == spacing)
        #expect(viewModel.verticalPadding?.bottomPadding == spacing)
        #expect(viewModel.horizontalPadding?.leadingPadding == spacing)
        #expect(viewModel.horizontalPadding?.trailingPadding == spacing)
    }
    
    @Test("convenience init keeps default padding")
    func convenienceInitKeepsDefaultPadding() {
        let spacing = CGFloat(DesignSystem.Spacing.default)
        let viewModel = GDSErrorIconTitleViewModel(
            icon: .error,
            title: "There is a problem"
        )
        
        #expect(viewModel.verticalPadding?.topPadding == spacing)
        #expect(viewModel.verticalPadding?.bottomPadding == spacing)
        #expect(viewModel.horizontalPadding?.leadingPadding == spacing)
        #expect(viewModel.horizontalPadding?.trailingPadding == spacing)
    }
}
