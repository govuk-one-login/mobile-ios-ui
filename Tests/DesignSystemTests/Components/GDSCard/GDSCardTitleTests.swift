@testable import DesignSystem
import UIKit
import Testing

@MainActor
struct GDSCardTitleTests {
    @Test("""
          Test default stack view config
    """)
    func defaultStackViewConfig() throws {
        let viewModel = GDSCardTitleViewModel(
            title: "test title"
        )
        let sut = GDSCardTitleView(viewModel: viewModel)
        #expect(sut.axis == .vertical)
        #expect(sut.alignment == .leading)
        #expect(sut.spacing == 0)
        #expect(sut.distribution == .fill)
    }
    
    @Test("""
          Test default values
    """)
    func defaultValues() throws {
        let viewModel = GDSCardTitleViewModel(
            title: "test title"
        )
        let sut = GDSCardTitleView(viewModel: viewModel)
        let label = try #require(sut.arrangedSubviews[1] as? UILabel)
        #expect(label.text == "test title")
        #expect(label.textColor == DesignSystem.Color.Text.primary)
        #expect(label.textAlignment == .left)
        #expect(label.numberOfLines == 0)
        #expect(label.lineBreakMode == .byWordWrapping)
        #expect(label.adjustsFontForContentSizeCategory == true)
        #expect(label.accessibilityTraits == [])
        #expect(label.accessibilityIdentifier == "content-card-title")
    }
    
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSCardTitleViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.caption1,
            alignment: .center,
            accessibilityTraits: .header
        )
        let sut = GDSCardTitleView(viewModel: viewModel)
        let label = try #require(sut.arrangedSubviews[1] as? UILabel)
        #expect(label.text == "test title")
        #expect(label.textAlignment == .center)
        #expect(label.accessibilityTraits == .header)
    }
}
