@testable import DesignSystem
import Testing
import UIKit

struct TestGDSScreenViewModel: GDSScreenViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
}

@MainActor
struct GDSScreenTests {
    @Test("Top centred with empty arrays (no input) configures the view correctly")
    func topCentredNoInput() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.containerStackView.arrangedSubviews.count == 2)
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 2)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.isEmpty)
        #expect(sut.bottomStackView.arrangedSubviews.isEmpty)
    }
    
    @Test("Centred with empty arrays (no input) configures the view correctly")
    func centredNoInput() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .centred,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 3)
    }
    
    @Test("Ensure that when the content item's padding is not set, default padding is applied")
    func defaultPadding() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .centred,
            body: [GDSTextViewModel(
                title: "test body text",
                verticalPadding: nil,
                horizontalPadding: nil
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let bodyItemStack = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        #expect(
            bodyItemStack.directionalLayoutMargins == NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )
        )
    }
    
    @Test("Top centred screen configures the view correctly")
    func inputConfiguresCorrectly() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "test body text")],
            movableFooter: [GDSTextViewModel(title: "test footer text")],
            footer: [GDSButtonViewModel(
                title: "test button text",
                style: .primary,
                buttonAction: .action({})
            )]
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
        let bodyItemStack = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        let bodyTextItem = try #require(bodyItemStack.arrangedSubviews.first as? GDSTextView)
        #expect(bodyTextItem.text == "test body text")
        
        #expect(sut.bottomStackView.arrangedSubviews.count == 2)
        let footerItemStack = try #require(sut.bottomStackView.arrangedSubviews.first as? UIStackView)
        let footerButtonItem = try #require(footerItemStack.arrangedSubviews.first as? GDSTextView)
        #expect(footerButtonItem.text == "test footer text")
        
        let bottomItemStack = try #require(sut.bottomStackView.arrangedSubviews[1] as? UIStackView)
        let bottomButtonItem = try #require(bottomItemStack.arrangedSubviews.first as? GDSButton)
        #expect(bottomButtonItem.titleLabel?.text == "test button text")
    }
    
    @Test("Calling the move content functions reconfigure the view correctly")
    func moveContentMethods() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "test body text")],
            movableFooter: [GDSTextViewModel(title: "test footer text")],
            footer: [GDSButtonViewModel(
                title: "test button text",
                style: .primary,
                buttonAction: .action({})
            )]
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
        #expect(sut.bottomStackView.arrangedSubviews.count == 2)
        
        sut.movableFooterToScrollView()
        
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 2)
        #expect(sut.bottomStackView.arrangedSubviews.count == 1)
        
        sut.movableFooterToBottomStackView()
        
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
        #expect(sut.bottomStackView.arrangedSubviews.count == 2)
    }
    
    @Test("First accessibility element in scroll view responds to user interaction for Full Keyboard Access")
    func scrollViewAccessibility_textBody() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "test body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let bodyItemStack = sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView
        let textView = bodyItemStack?.arrangedSubviews.first as? GDSTextView
        // UILabel.isAccessibilityElement is true at runtime but not in unit tests,
        // so set it explicitly to simulate runtime behaviour
        textView?.isAccessibilityElement = true
        
        sut.configureScrollViewAccessibility()
        
        #expect(textView?.accessibilityRespondsToUserInteraction == true)
    }
    
    @Test("First accessibility element in GDSList body responds to user interaction for Full Keyboard Access")
    func scrollViewAccessibility_listBody() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSListViewModel(
                title: GDSLocalisedString(stringKey: "test"),
                items: [GDSLocalisedString(stringKey: "item1")],
                style: .numbered
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let bodyItemStack = sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView
        let list = bodyItemStack?.arrangedSubviews.first as? GDSList
        // GDSList rows have isAccessibilityElement = true set in createRow()
        // Find the first row stack view
        let listStack = list?.subviews.first as? UIStackView
        // First arranged subview after the title is the first row
        let firstRow = listStack?.arrangedSubviews.first(where: { $0.isAccessibilityElement })
        
        sut.configureScrollViewAccessibility()
        
        #expect(firstRow?.accessibilityRespondsToUserInteraction == true)
    }
    
    @Test("Empty body does not crash when configuring scroll view accessibility")
    func scrollViewAccessibility_emptyBody() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        sut.configureScrollViewAccessibility()
    }
}
