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
    
    let didAppear: Action?
    let didDismiss: Action?
}

struct TestGDSLeftAlignedScreenViewModel: GDSLeftAlignedViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    let rightBarButtonTitle: GDSLocalisedString?
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    
    let didAppear: Action?
    let didDismiss: Action?
}

struct TestGDSErrorScreenViewModel: GDSErrorScreenViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    
    let rightBarButtonTitle: GDSLocalisedString?
    let backButtonTitle: GDSLocalisedString?
    let backButtonIsHidden: Bool
    
    let didAppear: Action?
    let didDismiss: Action?
}
