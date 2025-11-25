//@testable import DesignSystem
//import Testing
//import UIKit
//
//@MainActor
//struct GDSListViewTests {
//    // Numbered List Tests
//    @Test("Numbered list title is set correctly")
//    func test_numbered_title() throws {
//        let sut = GDSListView(viewModel: MockNumberedListViewModel())
//        let titleLabel: UILabel? = sut[child: "numbered-list-title-label"]
//        #expect(titleLabel?.text == "Test numbered list view")
//        #expect(titleLabel?.font == DesignSystem.Font.Base.headline)
//        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
//        #expect(titleLabel?.textAlignment == .left)
//        #expect(titleLabel?.numberOfLines == 0)
//    }
//    
//    @Test("Accessibility label for first row in numbered List")
//    func test_numberedList_firstRow_accessibilityLabel() throws {
//        let sut = GDSListView(viewModel: MockNumberedListViewModel())
//        let firstRow: UIStackView? = sut[child: "numbered-list-row-stack-view-1"]
//        
//        #expect(firstRow?.accessibilityLabel == "Numbered List 1, first numbered list item")
//    }
//    
//    @Test("Accessibility label for second row in numbered List")
//    func test_numberedList_secondRow_accessibilityLabel() throws {
//        let sut = GDSListView(viewModel: MockNumberedListViewModel())
//        let secondRow: UIStackView? = sut[child: "numbered-list-row-stack-view-2"]
//        
//        // discrepancy between first and second rows whyyy???????!!!
//        #expect(secondRow?.accessibilityLabel == "2, second numbered list item")
//    }
//    
//    @Test("Number label and content label are set correctly")
//    func test_numberedList_firstRow_number_and_text() throws {
//        let sut = GDSListView(viewModel: MockNumberedListViewModel())
//        let firstRow: UIStackView? = sut[child: "numbered-list-row-stack-view-1"]
//        let number = firstRow?.arrangedSubviews[0] as? UILabel
//        let label = firstRow?.arrangedSubviews[1] as? UILabel
//        
//        #expect(number != nil)
//        #expect(number?.text == "1.")
//        #expect(label?.text == "first numbered list item")
//        #expect(label?.font == DesignSystem.Font.Base.body)
//        #expect(label?.textAlignment == .left)
//        #expect(label?.adjustsFontForContentSizeCategory == true)
//        #expect(label?.numberOfLines == 0)
//    }
//    
//    // Bulleted List Tests
//    @Test("Numbered list title is set correctly")
//    func test_bulleted_title() throws {
//        let sut = GDSListView(viewModel: MockBulletedListViewModel())
//        let titleLabel: UILabel? = sut[child: "bulleted-list-title-label"]
//        #expect(titleLabel?.text == "Test bulleted list view")
//        #expect(titleLabel?.font == DesignSystem.Font.Base.headline)
//        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
//        #expect(titleLabel?.textAlignment == .left)
//        #expect(titleLabel?.numberOfLines == 0)
//    }
//    
//   @Test("Accessibility label for first row in numbered List")
//    func test_bulletedList_firstRow_accessibilityLabel() throws {
//        let sut = GDSListView(viewModel: MockBulletedListViewModel())
//        let firstRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-1"]
//        
//        #expect(firstRow?.accessibilityLabel == "Bulleted List 1, first bulleted list item")
//    }
//    
//    @Test("Accessibility label for second row in bulleted List")
//    func test_bulletedList_secondRow_accessibilityLabel() throws {
//        let sut = GDSListView(viewModel: MockBulletedListViewModel())
//        let secondRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-2"]
//        
//        #expect(secondRow?.accessibilityLabel == "2, second bulleted list item")
//    }
//    
//    @Test("Bullet point and content label are set correctly")
//    func test_bulletedList_firstRow_bulletPoint_and_text() throws {
//        let sut = GDSListView(viewModel: MockBulletedListViewModel())
//        let firstRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-1"]
//        let bullet = firstRow?.arrangedSubviews[0] as? UIImageView
//        let label = firstRow?.arrangedSubviews[1] as? UILabel
//        
//        #expect(bullet != nil)
//        #expect(label?.text == "first bulleted list item")
//        #expect(label?.font == DesignSystem.Font.Base.body)
//        #expect(label?.textAlignment == .left)
//        #expect(label?.adjustsFontForContentSizeCategory == true)
//        #expect(label?.numberOfLines == 0)
//    }
//    
//    // Additional tests to consider - header trait and partial bold text
//    
//    
//    //    @Test(HEADER TRAITT!!)
//    //    func test_numbered_title_header_trait() throws {
//    //        let vm = MockNumberedListViewModel(titleConfig: (font: UIFont.preferredFont(forTextStyle: .body), isHeader: true))
//    //        let sut = GDSListView(viewModel: vm)
//    //
//    //        #expect(try sut.style.identifierPrefix.accessibilityTraits.contains("numbered-list-title-label"))
//    //    }
// 
//}
