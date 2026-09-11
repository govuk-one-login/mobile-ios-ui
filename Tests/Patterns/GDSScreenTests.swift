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
    
    @Test("ContentView with isAccessibilityElement true gets accessibilityRespondsToUserInteraction set")
    func contentView_accessibilityElementRespondsToUserInteraction() {
        // GDSList rows explicitly set isAccessibilityElement = true in createRow(),
        // so they get accessibilityRespondsToUserInteraction set at creation time
        let viewModel = GDSListViewModel(
            title: GDSLocalisedString(stringKey: "test"),
            items: [GDSLocalisedString(stringKey: "item1")],
            style: .numbered
        )
        let view = viewModel.createUIView() as? GDSList
        let listStack = view?.subviews.first as? UIStackView
        let firstRow = listStack?.arrangedSubviews.first(where: { $0.isAccessibilityElement })
        
        #expect(firstRow?.accessibilityRespondsToUserInteraction == true)
    }
    
    @Test("ContentView without accessibility elements does not crash")
    func contentView_noAccessibilityElements() {
        let viewModel = GDSTextViewModel(title: "test text")
        // Should not crash even if isAccessibilityElement is false in test environment
        _ = viewModel.createUIView()
    }

    @Test("hugContents button gets a leading-aligned wrapper stack")
    func hugContentsButtonWrapperIsLeadingAligned() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSButtonViewModel(
                title: "Share",
                style: .secondaryOutline,
                buttonAction: .action({})
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        let wrapper = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        let button = try #require(wrapper.arrangedSubviews.first as? GDSButton)
        #expect(button.titleLabel?.text == "Share")
        // The wrapper must not pin both horizontal edges (which would stretch the
        // button); it uses the button's leading alignment instead.
        #expect(wrapper.alignment == .leading)
    }

    @Test("fill button keeps a fill-aligned wrapper stack")
    func fillButtonWrapperIsFillAligned() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSButtonViewModel(
                title: "Primary",
                style: .primary,
                buttonAction: .action({})
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        let wrapper = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        #expect(wrapper.alignment == .fill)
    }

    @Test("button with explicit padding applies horizontal insets and vertical row spacing")
    func buttonPaddingAppliesToWrapperMargins() throws {
        // Mirrors the demo Buttons screen: each button carries 16pt horizontal
        // padding and 8pt top/bottom padding (8 + 8 between rows = 16pt spacing).
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSButtonViewModel(
                title: "Primary",
                style: .primary,
                buttonAction: .action({}),
                verticalPadding: .vertical(8),
                horizontalPadding: .horizontal(16)
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        let wrapper = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        #expect(
            wrapper.directionalLayoutMargins == NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )
        )
    }
}
