@testable import DesignSystem
import UIKit
import Testing

@MainActor
struct GDSCardImageTests {
    @Test("""
          Test default values
    """)
    func defaultValues() throws {
        let viewModel = GDSCardImageViewModel(
            image: UIImage(),
            contentMode: .scaleAspectFill
        )
        let sut = GDSCardImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.contentMode == .scaleAspectFill)
        #expect(sut.layer.cornerRadius == 12)
        #expect(sut.layer.masksToBounds == true)
        #expect(sut.layer.maskedCorners == [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        #expect(sut.translatesAutoresizingMaskIntoConstraints == false)
        #expect(sut.constraints.isEmpty)
    }
    
    @Test("""
          Test set values
    """)
    func setValues() throws {
        let viewModel = GDSCardImageViewModel(
            image: UIImage(),
            accessibilityLabel: "accessibility string",
            contentMode: .scaleAspectFit
        )
        let sut = GDSCardImageView(viewModel: viewModel)
        #expect(sut.image == UIImage())
        #expect(sut.contentMode == .scaleAspectFit)
        #expect(sut.layer.cornerRadius == 12)
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
