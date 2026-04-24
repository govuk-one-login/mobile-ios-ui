@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSDividerTests {
    @Test("""
          Test default values
    """)
    func defaultValues() throws {
        let viewModel = GDSDividerViewModel()
        let sut = GDSDividerView(viewModel: viewModel)
        #expect(sut.backgroundColor == DesignSystem.Color.Dividers.card)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == (1 / UIScreen.main.scale) && $0.isActive
        }))
        #expect(sut.accessibilityIdentifier == "gds-divider-view")
    }
    
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSDividerViewModel(
            height: 3,
            colour: DesignSystem.Color.Dividers.default
        )
        let sut = GDSDividerView(viewModel: viewModel)
        #expect(sut.backgroundColor == DesignSystem.Color.Dividers.default)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == (3 / UIScreen.main.scale) && $0.isActive
        }))
    }
}
