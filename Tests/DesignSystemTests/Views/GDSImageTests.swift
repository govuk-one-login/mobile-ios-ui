@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSImageTests {
    @Test("Test default values")
    func defaultValues() throws {
        let viewModel = GDSImageViewModel(
            image: UIImage(),
            contentMode: .scaleAspectFill
        )
        let sut = GDSImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.contentMode == .scaleAspectFill)
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.card)
        #expect(sut.layer.masksToBounds == true)
        #expect(sut.layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(sut.translatesAutoresizingMaskIntoConstraints == false)
        #expect(sut.constraints.isEmpty)
    }
    
    @Test("Test set values")
    func setValues() throws {
        let viewModel = GDSImageViewModel(
            image: UIImage(),
            accessibilityLabel: "accessibility string",
            contentMode: .scaleAspectFit
        )
        let sut = GDSImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.contentMode == .scaleAspectFit)
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.card)
        #expect(sut.layer.masksToBounds == true)
        #expect(sut.layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(sut.translatesAutoresizingMaskIntoConstraints == false)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.isActive
        }))
        #expect(sut.isAccessibilityElement)
        #expect(sut.accessibilityLabel == "accessibility string")
    }
}
