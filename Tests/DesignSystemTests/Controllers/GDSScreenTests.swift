@testable import DesignSystem
import UIKit
import Testing

struct TestGDSScreenViewModel: GDSScreenViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
    }
}

@MainActor
struct GDSScreenTests {
    @Test
    func noInputScreen() async throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .topCentred,
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
    
    @Test
    func noInput() async throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .centred,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 3)
    }
    
    @Test
    func input() async throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .topCentred,
            body: [GDSCardTextViewModel(title: "test body text")],
            movableFooter: [GDSCardTextViewModel(title: "test footer text")],
            footer: [GDSButtonViewModel(
                title: "test button text",
                style: .primary,
                buttonAction: .action({})
            )]
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewInnerStackView.arrangedSubviews.count == 1)
        let bodyItemStack = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        let bodyTextItem = try #require(bodyItemStack.arrangedSubviews.first as? GDSCardTextView)
        #expect(bodyTextItem.text == "test body text")
        
        #expect(sut.bottomStackView.arrangedSubviews.count == 2)
        let footerItemStack = try #require(sut.bottomStackView.arrangedSubviews.first as? UIStackView)
        let footerButtonItem = try #require(footerItemStack.arrangedSubviews.first as? GDSCardTextView)
        #expect(footerButtonItem.text == "test footer text")
        
        let bottomItemStack = try #require(sut.bottomStackView.arrangedSubviews[1] as? UIStackView)
        let bottomButtonItem = try #require(bottomItemStack.arrangedSubviews.first as? GDSButton)
        #expect(bottomButtonItem.titleLabel?.text == "test button text")
    }
}
