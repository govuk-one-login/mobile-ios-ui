@testable import DesignSystem
import Testing
import UIKit

@MainActor
struct GDSContentCardViewModelTests {
    @Test("""
        Check configuration of the outer stack view
    """)
    func encasingStackConfig() throws {
        let card = GDSContentCardViewModel(
            items: [],
            showShadow: false,
            dismissAction: nil
        )
        let cardStackView = try #require(card.uiView.subviews.first as? UIStackView)
        
        #expect(cardStackView.spacing == .zero)
        #expect(cardStackView.alignment == .fill)
        #expect(cardStackView.distribution == .fill)
        #expect(cardStackView.layer.cornerRadius == 12)
        #expect(cardStackView.layer.masksToBounds == true)
        #expect(cardStackView.translatesAutoresizingMaskIntoConstraints == false)
        #expect(cardStackView.backgroundColor == .systemBackground)
    }
    
    @Test("""
        Check shadow is show for the outer stack view
    """)
    func encasingStackShadow() throws {
        let card = GDSContentCardViewModel(
            items: [],
            showShadow: true,
            dismissAction: nil
        )
        let cardStackView = try #require(card.uiView.subviews.first as? UIStackView)

        #expect(cardStackView.layer.shadowRadius == 10)
        #expect(cardStackView.layer.shadowOffset == CGSize(width: 0, height: 3))
        #expect(cardStackView.layer.shadowOpacity == 0.1)
        #expect(cardStackView.layer.shadowColor == DesignSystem.Color.Base.black1.cgColor)
        #expect(cardStackView.layer.masksToBounds == false)
    }
    
    @Test("""
        Check first inner stack view config is correct
    """)
    func innerStackViewConfig() throws {
        let title = ContentTitleViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1,
            verticalPadding: .vertical(.zero),
            horizontalPadding: .horizontal(.zero)
        )
        let card = GDSContentCardViewModel(
            items: [
                title
            ],
            showShadow: false,
            dismissAction: nil
        )
        let cardStackView = try #require(card.uiView.subviews.first as? UIStackView)

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
        let title = ContentTitleViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1
        )
        let card = GDSContentCardViewModel(
            items: [
                title
            ],
            showShadow: false,
            dismissAction: .action({ })
        )
        let cardStackView = try #require(card.uiView.subviews.first as? UIStackView)
        let titleStackView = try #require(cardStackView.arrangedSubviews.first as? UIStackView)
        
        #expect(titleStackView.arrangedSubviews.count == 2)
        #expect(titleStackView.arrangedSubviews.first is UILabel)
        #expect(titleStackView.arrangedSubviews[1] is GDSButton)
    }
    
    @Test("""
        Check the image stack view gets a dismiss button added as a subview and not the title
    """)
    func imageLabelHasDismissButton() throws {
        let image = ContentImageViewModel(
            image: UIImage(),
            contentMode: .scaleAspectFit
        )
        let title = ContentTitleViewModel(
            title: "test title",
            titleFont: DesignSystem.Font.Base.title1
        )
        let card = GDSContentCardViewModel(
            items: [
                image,
                title
            ],
            showShadow: false,
            dismissAction: .action({ })
        )
        let cardStackView = try #require(card.uiView.subviews.first as? UIStackView)
        let imageStackView = try #require(cardStackView.arrangedSubviews.first as? UIStackView)
        
        #expect(imageStackView.subviews.count == 2)
        #expect(imageStackView.subviews.first is UIImageView)
        #expect(imageStackView.subviews[1] is GDSButton)
        
        let titleStackView = try #require(cardStackView.arrangedSubviews[1] as? UIStackView)
        #expect(titleStackView.arrangedSubviews.count == 1)
    }
}
