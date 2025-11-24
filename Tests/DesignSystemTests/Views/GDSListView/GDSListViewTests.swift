@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSListViewTests {
    // Numbered List Tests
    @Test
    func test_numbered_title() throws {
        let sut = GDSListView(viewModel: MockNumberedListViewModel())
        let titleLabel: UILabel? = sut[child: "numbered-list-title-label"]
        #expect(titleLabel?.text == "Test numbered list view")
        #expect(titleLabel?.font == DesignSystem.Font.Base.headline)
        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
        #expect(titleLabel?.textAlignment == .left)
        #expect(titleLabel?.numberOfLines == 0)
    }
    
    // Bulleted List Tests
    @Test
    func test_bulleted_title() throws {
        let sut = GDSListView(viewModel: MockBulletedListViewModel())
        let titleLabel: UILabel? = sut[child: "bulleted-list-title-label"]
        #expect(titleLabel?.text == "Test bulleted list view")
        #expect(titleLabel?.font == DesignSystem.Font.Base.headline)
        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
        #expect(titleLabel?.textAlignment == .left)
        #expect(titleLabel?.numberOfLines == 0)
    }
}
