@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSListViewTests {
    
    private func numberedListViewModel() -> GDSListViewModel {
        GDSListViewModel(
        title: GDSLocalisedString(stringKey: "Test numbered list view"),
        titleConfig: TitleConfig(
            font: DesignSystem.Font.Base.headline, isHeader: true),
        items: [
            GDSLocalisedString(stringKey: "first numbered list item"),
            GDSLocalisedString(stringKey: "second numbered list item")],
        style: .numbered
        )
    }
    
    private func bulletedListViewModel() -> GDSListViewModel {
        GDSListViewModel(
        title: GDSLocalisedString(stringKey: "Test bulleted list view"),
        titleConfig: TitleConfig(
            font: DesignSystem.Font.Base.body, isHeader: false),
        items: [
            GDSLocalisedString(stringKey: "first bulleted list item"),
            GDSLocalisedString(stringKey: "second bulleted list item")],
        style: .bulleted
        )
    }
    // Numbered List Tests
    @Test("Numbered list title is set correctly")
    func test_numbered_title() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let titleLabel: UILabel? = sut[child: "numbered-list-title-label"]
        #expect(titleLabel?.text == "Test numbered list view")
        #expect(titleLabel?.font == DesignSystem.Font.Base.headline)
        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
        #expect(titleLabel?.textAlignment == .left)
        #expect(titleLabel?.numberOfLines == 0)
    }
    
    @Test("Numbered list title has header accessibility trait")
    func test_numbered_title_headerTrait() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let titleLabel: UILabel? = sut[child: "numbered-list-title-label"]
        #expect(titleLabel?.accessibilityTraits.contains(.header) == true)
    }
    
    @Test("Accessibility label for first row in numbered List")
    func test_numberedList_firstRow_accessibilityLabel() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let firstRow: UIStackView? = sut[child: "numbered-list-row-stack-view-1"]
        
        #expect(firstRow?.accessibilityLabel == "Numbered List 1, first numbered list item")
    }
    
    @Test("Accessibility label for second row in numbered List")
    func test_numberedList_secondRow_accessibilityLabel() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let secondRow: UIStackView? = sut[child: "numbered-list-row-stack-view-2"]
        
        #expect(secondRow?.accessibilityLabel == "2, second numbered list item")
    }
    
    @Test("Number label and content label are set correctly")
    func test_numberedList_firstRow_number_and_text() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let firstRow: UIStackView? = sut[child: "numbered-list-row-stack-view-1"]
        let number = firstRow?.arrangedSubviews[0] as? UILabel
        let label = firstRow?.arrangedSubviews[1] as? UILabel
        
        #expect(number != nil)
        #expect(number?.text == "1.")
        #expect(label?.text == "first numbered list item")
        #expect(label?.font == DesignSystem.Font.Base.body)
        #expect(label?.textAlignment == .left)
        #expect(label?.adjustsFontForContentSizeCategory == true)
        #expect(label?.numberOfLines == 0)
    }
    
    @Test("Number labels all share the same width")
    func test_numberLabels_equalWidths() throws {
        let sut = GDSList(viewModel: numberedListViewModel())
        let firstRow: UIStackView? = sut[child: "numbered-list-row-stack-view-1"]
        let secondRow: UIStackView? = sut[child: "numbered-list-row-stack-view-2"]
        let firstNumber = firstRow?.arrangedSubviews[0] as? UILabel
        let secondNumber = secondRow?.arrangedSubviews[0] as? UILabel
        
        #expect(firstNumber?.frame.width == secondNumber?.frame.width)
    }
    
    
    // Bulleted List Tests
    @Test("Numbered list title is set correctly")
    func test_bulleted_title() throws {
        let sut = GDSList(viewModel: bulletedListViewModel())
        let titleLabel: UILabel? = sut[child: "bulleted-list-title-label"]
        #expect(titleLabel?.text == "Test bulleted list view")
        #expect(titleLabel?.font == DesignSystem.Font.Base.body)
        #expect(titleLabel?.adjustsFontForContentSizeCategory == true)
        #expect(titleLabel?.textAlignment == .left)
        #expect(titleLabel?.numberOfLines == 0)
    }
    
    @Test("Numbered list title has header accessibility trait")
    func test_bulleted_title_headerTrait_false() throws {
        let sut = GDSList(viewModel: bulletedListViewModel())
        let titleLabel: UILabel? = sut[child: "bulleted-list-title-label"]
        #expect(titleLabel?.accessibilityTraits.contains(.header) == false)
    }
    
   @Test("Accessibility label for first row in numbered List")
    func test_bulletedList_firstRow_accessibilityLabel() throws {
        let sut = GDSList(viewModel: bulletedListViewModel())
        let firstRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-1"]
        
        #expect(firstRow?.accessibilityLabel == "Bulleted List 1, first bulleted list item")
    }
    
    @Test("Accessibility label for second row in bulleted List")
    func test_bulletedList_secondRow_accessibilityLabel() throws {
        let sut = GDSList(viewModel: bulletedListViewModel())
        let secondRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-2"]
        
        #expect(secondRow?.accessibilityLabel == "2, second bulleted list item")
    }
    
    @Test("Bullet point and content label are set correctly")
    func test_bulletedList_firstRow_bulletPoint_and_text() throws {
        let sut = GDSList(viewModel: bulletedListViewModel())
        let firstRow: UIStackView? = sut[child: "bulleted-list-row-stack-view-1"]
        let bullet = firstRow?.arrangedSubviews[0] as? UIImageView
        let label = firstRow?.arrangedSubviews[1] as? UILabel
        
        #expect(bullet?.image != nil)
        #expect(bullet?.contentHuggingPriority(for: .horizontal) == .required)
        #expect(label?.text == "first bulleted list item")
        #expect(label?.font == DesignSystem.Font.Base.body)
        #expect(label?.textAlignment == .left)
        #expect(label?.adjustsFontForContentSizeCategory == true)
        #expect(label?.numberOfLines == 0)
    }
}
