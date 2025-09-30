@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSTextTests {
    @Test("Test default values")
    func defaultValues() throws {
        let viewModel = GDSTextViewModel(
            title: "test title"
        )
        let sut = GDSTextView(viewModel: viewModel)
        #expect(sut.text == "test title")
        #expect(sut.font == DesignSystem.Font.Base.body)
        #expect(sut.textColor == DesignSystem.Color.Text.primary)
        #expect(sut.textAlignment == .left)
        #expect(sut.numberOfLines == 0)
        #expect(sut.lineBreakMode == .byWordWrapping)
        #expect(sut.adjustsFontForContentSizeCategory == true)
        #expect(sut.accessibilityTraits == [])
        #expect(sut.accessibilityIdentifier == "gds-text-view")
    }
    
    @Test("Test set values")
    func setValues() throws {
        let viewModel = GDSTextViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.caption1,
            alignment: .center,
            accessibilityTraits: .header
        )
        let sut = GDSTextView(viewModel: viewModel)
        #expect(sut.text == "test title")
        #expect(sut.font == DesignSystem.Font.Base.caption1)
        #expect(sut.textAlignment == .center)
        #expect(sut.accessibilityTraits == .header)
    }
}
