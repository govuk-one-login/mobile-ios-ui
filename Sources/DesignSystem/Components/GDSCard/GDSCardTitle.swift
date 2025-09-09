import UIKit

public struct GDSCardTitleViewModel: ContentViewModel {
    public typealias ViewType = GDSCardTitleView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let alignment: NSTextAlignment
    let accessibilityTraits: UIAccessibilityTraits?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.title2Bold,
        alignment: NSTextAlignment = .left,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.alignment = alignment
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

public final class GDSCardTitleView: UIStackView, ContentView {
    public init(viewModel: GDSCardTitleViewModel) {
        super.init(frame: .zero)
        
        let paddingView = UIView()
        paddingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        let label = UILabel()
        label.font = viewModel.titleFont
        label.textColor = DesignSystem.Color.Text.primary
        if let attributedTitle = viewModel.title.attributedValue {
            label.attributedText = attributedTitle
        } else {
            label.text = viewModel.title.value
        }
        label.textAlignment = viewModel.alignment
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        if let accessibilityTraits = viewModel.accessibilityTraits {
            label.accessibilityTraits = accessibilityTraits
        }
        label.accessibilityIdentifier = "content-card-title"
        self.addArrangedSubview(paddingView)
        self.addArrangedSubview(label)
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 0
        self.distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
