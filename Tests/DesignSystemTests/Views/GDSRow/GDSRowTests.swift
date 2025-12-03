@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSRowTests {
    @Test("Initialise a Tall row with only title")
    func basicRowConfig() throws {
        let expectedTitle = "Test Title"
        let viewModel = GDSRowViewModel(titleConfig: StyledText(text: expectedTitle))
        let sut = viewModel.createUIView()
        
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 60 && $0.isActive
        }))
        
        let verticalStack = try #require(sut.subviews[0] as? UIStackView)
        
        #expect(verticalStack.axis == .vertical)
        #expect(verticalStack.arrangedSubviews.count == 1)
        
        let titleLabel = try #require(verticalStack.arrangedSubviews[0] as? UILabel)
        #expect(titleLabel.text == expectedTitle)
        #expect(titleLabel.font == DesignSystem.Font.Base.body)
        #expect(titleLabel.textColor == .label)
        
        #expect(sut.accessibilityLabel == ("\(expectedTitle)"))
        #expect(sut.accessibilityTraits == [])
    }
    
    @Test("Initialise a Tall row with only title, subtitle and icon")
    func tallTitleSubtitleRowConfig() throws {
        let expectedTitle = "Test Title"
        let expectedSubtitle = "Test Subtitle"
        let viewModel = GDSRowViewModel(
            titleConfig: StyledText(text: expectedTitle),
            subtitleConfig: StyledText(text: expectedSubtitle),
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let sut = viewModel.createUIView()
        
        let verticalStack = try #require(sut.subviews[0] as? UIStackView)
        #expect(verticalStack.arrangedSubviews.count == 2)
        
        let subtitleLabel = try #require(verticalStack.arrangedSubviews[1] as? UILabel)
        #expect(subtitleLabel.text == expectedSubtitle)
        #expect(subtitleLabel.font == DesignSystem.Font.Base.subheadline)
        #expect(subtitleLabel.textColor == .secondaryLabel)
        
        let iconView = try #require(sut.subviews[1] as? UIImageView)
        #expect(iconView.image?.isSymbolImage == true)
        #expect(iconView.tintColor == .tertiaryLabel)
        
        #expect(sut.accessibilityLabel == ("\(expectedTitle), \(expectedSubtitle)"))
        #expect(sut.accessibilityTraits == [])
    }
    
    @Test("Initialise a Tall row with image, title, subtitle, detail and icon")
    func allRowConfig() throws {
        let expectedTitle = "Test Title"
        let expectedSubtitle = "Test Subtitle"
        let expectedDetail = "14"
        let expectedImageAltText = "veteran card icon"
        let viewModel = GDSRowViewModel(
            titleConfig: StyledText(text: expectedTitle),
            subtitleConfig: StyledText(text: expectedSubtitle),
            detailConfig: StyledText(text: expectedDetail),
            image: UIImage(named: "vetCard", in: .module, compatibleWith: nil),
            imageAltText: expectedImageAltText,
            iconConfig: StyledIcon(icon: "chevron.right")
        )
        let sut = viewModel.createUIView()
        
        #expect(sut.subviews.count == 4)
        
        let vetCardImageView = try #require(sut.subviews[0] as? UIImageView)
        let verticalStack = try #require(sut.subviews[1] as? UIStackView)
        let detailLabel = try #require(sut.subviews[2] as? UILabel)
        #expect(sut.subviews[3] is UIImageView)
        
        #expect(vetCardImageView.constraints.contains(where: {
            $0.firstAttribute == .width && $0.constant == 42 && $0.isActive
        }))
        #expect(verticalStack.arrangedSubviews.count == 2)

        #expect(detailLabel.text == expectedDetail)
        #expect(detailLabel.font == DesignSystem.Font.Base.body)
        #expect(detailLabel.textColor == .secondaryLabel)
        #expect(detailLabel.constraints.contains(where: {
            $0.firstAttribute == .width && $0.constant == 45 && $0.isActive
        }))
        
        #expect(sut.accessibilityLabel == ("\(expectedImageAltText), \(expectedTitle), \(expectedSubtitle), \(expectedDetail)"))
        #expect(sut.accessibilityTraits == [])
    }
    
    @Test("Initialise a Regular row with only title, subtitle and icon")
    func regularTitleSubtitleIconRowConfig() throws {
        let expectedTitle = "Test Title"
        let expectedSubtitle = "Test Subtitle"
        let expectedIconAltText = "icon alt text"
        let action = {
                UIApplication.shared.open(URL(string: "https://www.google.com")!)
            }
        let viewModel = GDSRowViewModel(
            titleConfig: StyledText(text: expectedTitle),
            subtitleConfig: StyledText(text: expectedSubtitle),
            iconConfig: StyledIcon(icon: "arrow.up.right", colour: .secondaryLabel, altText: expectedIconAltText),
            type: .regular,
            action: action
        )
        let sut = viewModel.createUIView()
        
        let verticalStack = try #require(sut.subviews[0] as? UIStackView)
        #expect(verticalStack.arrangedSubviews.count == 2)
        
        let subtitleLabel = try #require(verticalStack.arrangedSubviews[1] as? UILabel)
        #expect(subtitleLabel.text == expectedSubtitle)
        #expect(subtitleLabel.font == DesignSystem.Font.Base.footnote)
        #expect(subtitleLabel.textColor == .label)
        
        let iconView = try #require(sut.subviews[1] as? UIImageView)
        #expect(iconView.image?.isSymbolImage == true)
        #expect(iconView.tintColor == .secondaryLabel)
        
        #expect(sut.accessibilityLabel == ("\(expectedTitle), \(expectedSubtitle), \(expectedIconAltText)"))
        #expect(sut.accessibilityHint == ("Opens in web browser"))
        #expect(sut.accessibilityTraits == [.button])
    }
}
