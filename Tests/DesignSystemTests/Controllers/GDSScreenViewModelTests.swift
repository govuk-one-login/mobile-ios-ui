@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSScreenViewModelTests {@Test()
    func topCentredNoInput() {
        let viewModel = TestGDSCentreAlignedScreenViewModel(
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 2)
        #expect(sut.scrollViewInnerStackView.alignment == .fill)
    }
    
    @Test()
    func topCentred() {
        let viewModel = TestGDSLeftAlignedScreenViewModel(
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 2)
        #expect(sut.scrollViewInnerStackView.alignment == .leading)
    }
    
    @Test()
    func top() throws {
        let gdsImageViewModel = GDSImageViewModel(
            image: UIImage(),
            contentMode: .scaleAspectFit
        )
        let viewModel = TestGDSErrorScreenViewModel(
            icon: gdsImageViewModel,
            body: [],
            movableFooter: [],
            footer: []
        )
        let sut = GDSScreen(viewModel: viewModel)
        
        let bodyItemStack = try #require(sut.scrollViewInnerStackView.arrangedSubviews.first as? UIStackView)
        #expect(bodyItemStack.arrangedSubviews.first is GDSImageView)
        
        #expect(sut.scrollViewOuterStackView.arrangedSubviews.count == 3)
        #expect(sut.scrollViewInnerStackView.alignment == .fill)
    }
}

struct TestGDSCentreAlignedScreenViewModel: GDSCentreAlignedViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    let rightBarButtonTitle: GDSLocalisedString?
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
        self.rightBarButtonTitle = rightBarButtonTitle
        self.backButtonTitle = backButtonTitle
        self.backButtonIsHidden = backButtonIsHidden
    }
    
    func didAppear() { }
    func didDismiss() { }
}

struct TestGDSLeftAlignedScreenViewModel: GDSLeftAlignedViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    let rightBarButtonTitle: GDSLocalisedString?
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
        self.rightBarButtonTitle = rightBarButtonTitle
        self.backButtonTitle = backButtonTitle
        self.backButtonIsHidden = backButtonIsHidden
    }
    
    func didAppear() { }
    func didDismiss() { }
}

struct TestGDSErrorScreenViewModel: GDSErrorScreenViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    let rightBarButtonTitle: GDSLocalisedString?
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    
    init(
        screenStyle: GDSScreenStyle,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel],
        rightBarButtonTitle: GDSLocalisedString?,
        backButtonTitle: GDSLocalisedString?,
        backButtonIsHidden: Bool,
        didAppearAction: (() -> Void)?,
        didDismissAction: (() -> Void)?
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
        self.rightBarButtonTitle = rightBarButtonTitle
        self.backButtonTitle = backButtonTitle
        self.backButtonIsHidden = backButtonIsHidden
    }
    
    func didAppear() { }
    func didDismiss() { }
}
