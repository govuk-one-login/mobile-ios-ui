@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSCardViewTests {
    @Test("""
        Check configuration of the outer stack view
    """)
    func encasingStackConfig() throws {
        let viewModel = GDSCardViewModel(contentItems: { })
        let sut = GDSCard(viewModel: viewModel)
        let cardStackView = try #require(sut.subviews.first as? UIStackView)
        
        #expect(cardStackView.spacing == .zero)
        #expect(cardStackView.alignment == .fill)
        #expect(cardStackView.distribution == .fill)
        #expect(cardStackView.layer.cornerRadius == 14)
        #expect(cardStackView.layer.masksToBounds == true)
        #expect(cardStackView.translatesAutoresizingMaskIntoConstraints == false)
        #expect(cardStackView.backgroundColor == DesignSystem.Color.Backgrounds.card)
    }
    
    @Test("""
        Check shadow is show for the outer stack view
    """)
    func encasingStackShadowAndBorder() throws {
        let viewModel = GDSCardViewModel(
            borderStyle: BorderStyle(width: 1, color: .black),
            showShadow: true,
            contentItems: { }
        )
        let sut = GDSCard(viewModel: viewModel)
        let cardStackView = try #require(sut.subviews.first as? UIStackView)
        
        #expect(cardStackView.layer.borderWidth == 1)
        #expect(cardStackView.layer.borderColor == UIColor.black.cgColor)
        #expect(cardStackView.layer.shadowRadius == 16)
        #expect(cardStackView.layer.shadowOffset == CGSize(width: 0, height: 4))
        #expect(cardStackView.layer.shadowOpacity == 1)
        #expect(cardStackView.layer.shadowColor == DesignSystem.Color.Shadows.card.cgColor)
        #expect(cardStackView.layer.masksToBounds == false)
    }
    
    @Test("""
        Check first inner stack view config is correct
    """)
    func innerStackViewConfig() throws {
        let title = GDSCardTextViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1,
            verticalPadding: .vertical(.zero),
            horizontalPadding: .horizontal(.zero)
        )
        let viewModel = GDSCardViewModel(
            showShadow: false,
            dismissAction: nil
        ) { title }
        let sut = GDSCard(viewModel: viewModel)
        let cardStackView = try #require(sut.subviews.first as? UIStackView)
        
        #expect(cardStackView.arrangedSubviews.count == 1)
        
        let titleStackView = try #require(cardStackView.arrangedSubviews.first as? UIStackView)
        #expect(titleStackView.isLayoutMarginsRelativeArrangement == true)
        #expect(titleStackView.directionalLayoutMargins == NSDirectionalEdgeInsets(
            top: .zero,
            leading: .zero,
            bottom: .zero,
            trailing: .zero
        ))
        #expect(titleStackView.translatesAutoresizingMaskIntoConstraints == false)
        
    }
    
    @Test("""
        Check the title stack view gets a dismiss button added as an arranged subview
    """)
    func titleLabelHasDismissButton() throws {
        let title = GDSCardTitleViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1
        )
        let viewModel = GDSCardViewModel(
            showShadow: false,
            dismissAction: .action({ })
        ) { title }
        let sut = GDSCard(viewModel: viewModel)
        let cardStackView = try #require(sut.subviews.first as? UIStackView)
        let titleStackView = try #require(cardStackView.arrangedSubviews.first as? UIStackView)
        let titleVStack = try #require(titleStackView.arrangedSubviews.first as? UIStackView)
        
        #expect(titleStackView.arrangedSubviews.count == 2)
        #expect(titleVStack.arrangedSubviews[1] is UILabel)
        #expect(titleStackView.arrangedSubviews[1] is GDSButton)
    }
    
    @Test("""
        Check the image stack view gets a dismiss button added as a subview and not the title
    """)
    func imageLabelHasDismissButton() throws {
        let image = GDSCardImageViewModel(
            image: UIImage(),
            accessibilityLabel: "test image",
            contentMode: .scaleAspectFit
        )
        let title = GDSCardTextViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1
        )
        let viewModel = GDSCardViewModel(
            showShadow: false,
            dismissAction: .action({ })
        ) {
            image
            title
        }
        let sut = GDSCard(viewModel: viewModel)
        let cardStackView = try #require(sut.subviews.first as? UIStackView)
        let imageStackView = try #require(cardStackView.arrangedSubviews.first as? UIStackView)
        let imageView = try #require(imageStackView.subviews.first as? UIImageView)
        
        #expect(imageStackView.subviews.count == 2)
        #expect(imageView.isAccessibilityElement == true)
        #expect(imageView.accessibilityLabel == "test image")
        #expect(imageStackView.subviews[1] is GDSButton)
        
        let titleStackView = try #require(cardStackView.arrangedSubviews[1] as? UIStackView)
        #expect(titleStackView.arrangedSubviews.count == 1)
    }
}
