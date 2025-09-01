import UIKit

public struct GDSCardTitleViewModel: ContentViewModel {
    public typealias ViewType = GDSCardTitleView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let alignment: NSTextAlignment
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.title2Bold,
        alignment: NSTextAlignment = .left,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.alignment = alignment
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
        if let attributedTitle = viewModel.title.attributedValue {
            label.attributedText = attributedTitle
        } else {
            label.text = viewModel.title.value
        }
        label.textAlignment = viewModel.alignment
        label.numberOfLines = .zero
        label.adjustsFontForContentSizeCategory = true
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
