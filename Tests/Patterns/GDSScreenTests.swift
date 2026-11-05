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
    
    /// Lays the screen out inside a window at `size`, driving the real
    /// `viewDidLayoutSubviews` -> `checkBottomStackHeight()` path (rather than
    /// calling the move functions directly), so the movable-footer placement is
    /// decided against actual frame heights the way it is on device.
    private func layout(_ sut: GDSScreen, at size: CGSize) {
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.view.frame = window.bounds
        sut.view.setNeedsLayout()
        sut.view.layoutIfNeeded()
    }

    @Test("""
    Movable footer returns to the bottom stack after a short -> tall layout change \
    (regression: portrait -> landscape -> portrait left it stranded in the scroll view)
    """)
    func movableFooterReturnsToBottomAfterRotation() throws {
        // Several footer items so the footer comfortably exceeds 1/3 of a short
        // (landscape-height) viewport but stays well under 1/3 of a tall
        // (portrait-height) viewport, making the threshold crossing deterministic
        // without depending on exact per-button metrics.
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "body")],
            movableFooter: [
                GDSButtonViewModel(title: "One", style: .primary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Two", style: .secondary, buttonAction: .action({})),
                GDSButtonViewModel(title: "Three", style: .secondary, buttonAction: .action({}))
            ],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)

        let portrait = CGSize(width: 390, height: 800)
        let landscape = CGSize(width: 800, height: 220)

        // Portrait: footer is short relative to the screen, so it stays pinned.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1) // body only

        // Landscape: footer now exceeds 1/3 of the short viewport, so it is moved
        // into the scroll view to remain reachable.
        layout(sut, at: landscape)
        #expect(sut.isMovableFooterInScrollView == true)
        #expect(sut.bottomStackView.arrangedSubviews.isEmpty)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 4) // body + 3 footer

        // Back to portrait: the footer must return to the pinned bottom stack.
        // Before the fix this reverse transition did not run against the settled
        // portrait geometry, leaving the footer stranded in the scroll view.
        layout(sut, at: portrait)
        #expect(sut.isMovableFooterInScrollView == false)
        #expect(sut.bottomStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
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
                style: .secondaryOutlined,
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
