@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSImageTests {
    @Test("Test default values")
    func defaultValues() throws {
        let viewModel = GDSImageViewModel(
            image: UIImage(),
            contentMode: .scaleAspectFill,
        )
        let sut = GDSImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.tintColor == .systemBlue)
        #expect(sut.contentMode == .scaleAspectFill)
        #expect(sut.layer.cornerRadius == .zero)
        #expect(sut.layer.masksToBounds == false)
        #expect(sut.layer.maskedCorners == CACornerMask(rawValue: 15))
        #expect(sut.translatesAutoresizingMaskIntoConstraints == true)
        #expect(sut.constraints.isEmpty)
        #expect(!sut.isAccessibilityElement)
        #expect(sut.accessibilityLabel == nil)
    }
    
    @Test("Test set values")
    func setValues() throws {
        let viewModel = GDSImageViewModel(
            image: UIImage(),
            imageColour: DesignSystem.Color.Base.black1,
            contentMode: .scaleAspectFit,
            imageHeightConstraint: 118,
            cornerMask: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            accessibilityLabel: "accessibility string"
        )
        let sut = GDSImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.tintColor == DesignSystem.Color.Base.black1)
        #expect(sut.contentMode == .scaleAspectFit)
        #expect(sut.layer.cornerRadius == DesignSystem.CornerRadius.card)
        #expect(sut.layer.masksToBounds == true)
        #expect(sut.layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(sut.translatesAutoresizingMaskIntoConstraints == false)
        #expect(sut.constraints.contains(where: {
            $0.firstAttribute == .height && $0.constant == 118 && $0.isActive
        }))
        #expect(sut.isAccessibilityElement)
        #expect(sut.accessibilityLabel == "accessibility string")
    }
}
