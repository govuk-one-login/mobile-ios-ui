@testable import DesignSystem
import UIKit
import Testing

@MainActor
struct GDSCardDividerTests {
    @Test("""
          Test default values
    """)
    func defaultValues() throws {
        let viewModel = GDSCardDividerViewModel()
        let sut = GDSCardDividerView(viewModel: viewModel)
        #expect(sut.backgroundColor == DesignSystem.Color.Dividers.card)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 1 && $0.isActive
        }))
        #expect(sut.accessibilityIdentifier == "divider")
    }
    
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSCardDividerViewModel(
            height: 5,
            colour: DesignSystem.Color.Dividers.default
        )
        let sut = GDSCardDividerView(viewModel: viewModel)
        #expect(sut.backgroundColor == DesignSystem.Color.Dividers.default)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 5 && $0.isActive
        }))
        #expect(sut.accessibilityIdentifier == "divider")
    }
}
