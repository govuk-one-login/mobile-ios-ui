@testable import DesignSystem
import UIKit
import Testing

@MainActor
struct GDSCardTextTests {
    @Test("""
          Test default values
    """)
    func defaultValues() throws {
        let viewModel = GDSCardTextViewModel(
            title: "test title"
        )
        let sut = GDSCardTextView(viewModel: viewModel)
        #expect(sut.text == "test title")
        #expect(sut.font == DesignSystem.Font.Base.body)
        #expect(sut.textColor == DesignSystem.Color.Text.primary)
        #expect(sut.textAlignment == .left)
        #expect(sut.numberOfLines == 0)
        #expect(sut.lineBreakMode == .byWordWrapping)
        #expect(sut.adjustsFontForContentSizeCategory == true)
        #expect(sut.accessibilityTraits == [])
        #expect(sut.accessibilityIdentifier == "content-card-label")
    }
    
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSCardTextViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.caption1,
            alignment: .center,
            accessibilityTraits: .header
        )
        let sut = GDSCardTextView(viewModel: viewModel)
        #expect(sut.text == "test title")
        #expect(sut.font == DesignSystem.Font.Base.caption1)
        #expect(sut.textAlignment == .center)
        #expect(sut.accessibilityTraits == .header)
    }
}
