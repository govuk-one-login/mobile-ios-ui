import DesignSystem
import Testing
import UIKit

@MainActor
struct HapticTests {
    @Test
    func allHaptics() async throws {
        Haptic.allCases.forEach {
            var didCallAction = false
            
            let viewModel = GDSButtonViewModel(
                title: TitleForState(normal: "test title"),
                style: .primary,
                buttonAction: .action(
                    { didCallAction = true }
                ),
                haptic: $0
            )
            
            let sut = GDSButton(viewModel: viewModel)
            
            #expect(didCallAction == false)
            sut.sendActions(for: .touchUpInside)
            #expect(didCallAction)
        }
    }
}
