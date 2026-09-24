@testable import DesignSystem
import Testing
import UIKit

struct TestGDSBackgrouncColorsViewModel: GDSScreenViewModel {
    let screenStyle: GDSScreenStyle
    let body: [any ContentViewModel]
    let movableFooter: [any ContentViewModel]
    let footer: [any ContentViewModel]
    let backgroundColor: UIColor?
    let footerBackgroundColor: UIColor?
}

@MainActor
struct GDSScreenBackgroundColorTests {
    @Test("GDSScreen background colors default to systemBackground and nil")
    func gdsScreenDefaults() async throws {
        let viewModel = TestGDSScreenViewModel(
            screenStyle: .top,
            body: [],
            movableFooter: [],
            footer: []
        )
        let gdsScreen = GDSScreen(viewModel: viewModel)
        
        
        #expect(gdsScreen.view.backgroundColor == .systemBackground)
        #expect(gdsScreen.bottomStackView.backgroundColor == nil)
    }
    
    @Test("GDSScreen background colors are set on view and footer")
    func gdsScreenBackgroundColors() async throws {
        let viewModel = TestGDSBackgrouncColorsViewModel(
            screenStyle: .top,
            body: [],
            movableFooter: [],
            footer: [],
            backgroundColor: .systemRed,
            footerBackgroundColor: .systemGreen
        )
        let gdsScreen = GDSScreen(viewModel: viewModel)
        
        #expect(gdsScreen.view.backgroundColor == .systemRed)
        #expect(gdsScreen.bottomStackView.backgroundColor == .systemGreen)
    }
}
