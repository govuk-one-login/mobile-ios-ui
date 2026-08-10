@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSScreenFullHeightTests {
    // MARK: - GDSScreenStyle Tests
    
    @Test("fullHeight style has correct verticalAlignment and horizontalAlignment")
    func fullHeightStyleProperties() {
        let sut = GDSScreenStyle.fullHeight
        #expect(sut.verticalAlignment == .top)
        #expect(sut.horizontalAlignment == .fill)
        #expect(sut.usesScrollView == false)
        #expect(sut.defaultVerticalPadding.topPadding == 8)
        #expect(sut.defaultVerticalPadding.bottomPadding == 8)
        #expect(sut.defaultHorizontalPadding.leadingPadding == 16)
        #expect(sut.defaultHorizontalPadding.trailingPadding == 16)
    }
    
    // MARK: - Layout Tests
    
    @Test("fullHeight screen does NOT contain a scroll view in the container")
    func fullHeightNoScrollView() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let containerSubviews = sut.containerStackView.arrangedSubviews
        let hasScrollView = containerSubviews.contains(where: { $0 is UIScrollView })
        #expect(!hasScrollView)
    }
    
    @Test("fullHeight screen uses bodyContainerStackView as the first arranged subview")
    func fullHeightUsesBodyContainer() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.containerStackView.arrangedSubviews.count == 2)
        #expect(sut.containerStackView.arrangedSubviews.first === sut.bodyContainerStackView)
        #expect(sut.containerStackView.arrangedSubviews.last === sut.bottomStackView)
    }
    
    @Test("fullHeight screen body content is placed directly in bodyContainerStackView")
    func fullHeightBodyContentDirect() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [
                GDSTextViewModel(title: "first item"),
                GDSTextViewModel(title: "second item")
            ],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bodyContainerStackView.arrangedSubviews.count == 3)
        
        let firstStack = try #require(sut.bodyContainerStackView.arrangedSubviews.first as? UIStackView)
        let firstText = try #require(firstStack.arrangedSubviews.first as? GDSTextView)
        #expect(firstText.text == "first item")
        
        let secondStack = try #require(sut.bodyContainerStackView.arrangedSubviews[1] as? UIStackView)
        let secondText = try #require(secondStack.arrangedSubviews.first as? GDSTextView)
        #expect(secondText.text == "second item")
    }
    
    @Test("fullHeight screen has bodyContainerStackView with fill distribution")
    func fullHeightBodyContainerDistribution() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bodyContainerStackView.distribution == .fill)
        #expect(sut.bodyContainerStackView.alignment == .fill)
    }
    
    @Test("fullHeight screen has correct accessibility identifier on bodyContainerStackView")
    func fullHeightBodyContainerAccessibilityIdentifier() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bodyContainerStackView.accessibilityIdentifier == "gds-screen-body-container-stack-view")
    }
    
    // MARK: - Footer Tests
    
    @Test("fullHeight screen renders footer items in bottomStackView")
    func fullHeightFooterRendersInBottomStack() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: [GDSButtonViewModel(
                title: "Continue",
                style: .primary,
                buttonAction: .action({})
            )]
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bottomStackView.arrangedSubviews.count == 1)
        #expect(!sut.bottomStackView.isHidden)
        
        let footerStack = try #require(sut.bottomStackView.arrangedSubviews.first as? UIStackView)
        let button = try #require(footerStack.arrangedSubviews.first as? GDSButton)
        #expect(button.titleLabel?.text == "Continue")
    }
    
    @Test("fullHeight screen hides bottomStackView when footer is empty")
    func fullHeightEmptyFooterHidden() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bottomStackView.isHidden)
    }
    
    @Test("fullHeight screen with empty body has spacer only in bodyContainerStackView")
    func fullHeightEmptyBody() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.bodyContainerStackView.arrangedSubviews.count == 1)
    }
    
    // MARK: - VoiceOver Tests
    
    @Test("fullHeight screen VoiceOver focus returns first body view from bodyContainerStackView")
    func fullHeightVoiceOverFocus() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(title: "VoiceOver target")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let focusView = try sut.initialVoiceOverView
        let firstBodyView = sut.bodyContainerStackView.arrangedSubviews.first(where: { $0 is UIStackView })
        #expect(focusView === firstBodyView)
    }
    
    @Test("fullHeight screen VoiceOver throws when body is empty")
    func fullHeightVoiceOverThrowsWhenEmpty() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(throws: VoiceOverFocusError.self) {
            _ = try sut.initialVoiceOverView
        }
    }
    
    // MARK: - Default Padding Tests
    
    @Test("fullHeight screen applies default padding to body items")
    func fullHeightDefaultPadding() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .fullHeight,
            body: [GDSTextViewModel(
                title: "padded text",
                verticalPadding: nil,
                horizontalPadding: nil
            )],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let bodyItemStack = try #require(sut.bodyContainerStackView.arrangedSubviews.first as? UIStackView)
        #expect(
            bodyItemStack.directionalLayoutMargins == NSDirectionalEdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )
        )
    }
    
    // MARK: - Regression Tests (existing styles unchanged)
    
    @Test("top style still uses scroll view")
    func topStyleStillUsesScrollView() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(viewModel.screenStyle.usesScrollView == true)
        let containerSubviews = sut.containerStackView.arrangedSubviews
        let hasScrollView = containerSubviews.contains(where: { $0 is UIScrollView })
        #expect(hasScrollView)
        #expect(sut.containerStackView.arrangedSubviews.first === sut.scrollView)
    }
    
    @Test("centred style still uses scroll view")
    func centredStyleStillUsesScrollView() {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .centred,
            body: [GDSTextViewModel(title: "body text")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(viewModel.screenStyle.usesScrollView == true)
        let containerSubviews = sut.containerStackView.arrangedSubviews
        let hasScrollView = containerSubviews.contains(where: { $0 is UIScrollView })
        #expect(hasScrollView)
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 3)
    }
    
    @Test("top style VoiceOver still reads from scrollViewInnerStackView")
    func topStyleVoiceOverFromScrollView() throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [GDSTextViewModel(title: "scroll body")],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let focusView = try sut.initialVoiceOverView
        #expect(focusView === sut.scrollViewInnerStackView.arrangedSubviews.first)
    }
    
    // MARK: - Deallocation Test
    
    @Test("GDSScreen with fullHeight style deallocates correctly")
    func fullHeightDeallocation() async {
        weak var weakScreen: GDSScreen?
        
        autoreleasepool {
            let viewModel = TestGDSScreenViewModel(
                screenStyle: .fullHeight,
                body: [GDSTextViewModel(title: "body text")],
                movableFooter: [],
                footer: [GDSButtonViewModel(
                    title: "Continue",
                    style: .primary,
                    buttonAction: .action({})
                )]
            )
            let screen = GDSScreen(viewModel: viewModel)
            weakScreen = screen
            // Trigger viewDidLoad
            _ = screen.view
        }
        
        #expect(weakScreen == nil)
    }
}
