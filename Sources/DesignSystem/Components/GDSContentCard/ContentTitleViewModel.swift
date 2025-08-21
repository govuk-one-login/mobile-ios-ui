import UIKit

public struct ContentTitleViewModel {
    let title: GDSLocalisedString
    let titleFont: UIFont
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.titleFont = titleFont
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension ContentTitleViewModel: ContentItem {
    public var uiView: UIView {
        let label = UILabel()
        label.text = title.value
        label.font = titleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "content-card-title"
        return label
    }
}
