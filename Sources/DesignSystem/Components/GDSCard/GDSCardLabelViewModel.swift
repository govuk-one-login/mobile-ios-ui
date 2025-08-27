import UIKit

public struct GDSCardLabelViewModel {
    let title: GDSLocalisedString
    let titleFont: UIFont
    let alignment: NSTextAlignment
    public let isTitle: Bool
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.body,
        alignment: NSTextAlignment = .left,
        isTitle: Bool = false,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.alignment = alignment
        self.isTitle = isTitle
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension GDSCardLabelViewModel: ContentItem {
    public var uiView: UIView {
        let label = UILabel()
        label.font = titleFont
        if let attributedTitle = title.attributedValue {
            label.attributedText = attributedTitle
        } else {
            label.text = title.value
        }
        label.textAlignment = alignment
        label.numberOfLines = .zero
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "content-card-\(isTitle ? "title" : "label")"
        if isTitle {
            let paddingView = UIView()
            paddingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
            let stackView = UIStackView(views: paddingView, label, spacing: 0, distribution: .fill)
            return stackView
        }
        return label
    }
}
