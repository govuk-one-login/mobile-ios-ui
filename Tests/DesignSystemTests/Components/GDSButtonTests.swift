import DesignSystem
import UIKit
import Testing

@MainActor
struct GDSButtonTests {
    
    @Test func actionTest() {
        var didCallAction = false
        
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .action(
                { didCallAction = true }
            ),
            haptic: .success
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(didCallAction == false)
        sut.sendActions(for: .touchUpInside)
        #expect(didCallAction)
    }
    
    @Test func asyncActionTest() async throws {
        var didCallAction = false
        
        let viewModel = GDSButtonViewModel(
            title: TitleForState(normal: "test title"),
            style: .primary,
            buttonAction: .asyncAction(
                { didCallAction = true }
            ),
            haptic: .success
        )
        
        let sut = GDSButton(viewModel: viewModel)
        
        #expect(didCallAction == false)
        sut.sendActions(for: .touchUpInside)
        try await Task.sleep(seconds: 0.01)
        #expect(didCallAction)
    }
}
