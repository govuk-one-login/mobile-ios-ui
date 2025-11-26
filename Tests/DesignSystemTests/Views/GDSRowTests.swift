@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSRowTests {
    
    @Test("Initialise a Tall row with only title")
    func basicRowConfig() throws {
        let expectedTitle = "Test Title"
        let viewModel = GDSRowViewModel(title: expectedTitle)
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

        let divider = try #require(sut.subviews[1] as? GDSDividerView)
        #expect(divider.backgroundColor == .separator)
        #expect(divider.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 0.5 && $0.isActive
        }))
    }
    
    @Test("Initialise a Tall row with only title, subtitle and icon")
    func titleSubtitleRowConfig() throws {
        let expectedTitle = "Test Title"
        let expectedSubtitle = "Test Subtitle"
        let viewModel = GDSRowViewModel(
            title: expectedTitle,
            subtitle: expectedSubtitle,
            icon: "chevron.right"
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
    }
    
    @Test("Initialise a Tall row with image, title, subtitle, detail and icon")
    func allRowConfig() throws {
        let expectedTitle = "Test Title"
        let expectedSubtitle = "Test Subtitle"
        let expectedDetail = "14"
        let viewModel = GDSRowViewModel(
            title: expectedTitle,
            subtitle: expectedSubtitle,
            detail: expectedDetail,
            image: "vetCard",
            icon: "chevron.right"
        )
        let sut = viewModel.createUIView()
        
        #expect(sut.subviews.count == 5)
        
        let vetCardImageView = try #require(sut.subviews[0] as? UIImageView)
        let verticalStack = try #require(sut.subviews[1] as? UIStackView)
        let detailLabel = try #require(sut.subviews[2] as? UILabel)
        let iconView = try #require(sut.subviews[3] as? UIImageView)
        
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
    }
}
