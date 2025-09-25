@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSSymbolTests {
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSSymbolViewModel(
            image: UIImage(),
            imageColour: .black,
            accessibilityLabel: "symbol accessibility label",
            contentMode: .scaleAspectFit,
            imageHeightConstraint: 107,
            verticalPadding: nil,
            horizontalPadding: nil
        )
        let sut = GDSSymbolView(viewModel: viewModel)
        #expect(sut.image ==  UIImage())
        #expect(sut.contentMode == .scaleAspectFit)
        #expect(sut.isAccessibilityElement)
        #expect(sut.accessibilityLabel == "symbol accessibility label")
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.isActive && $0.constant == 118
        }))
    }
}
