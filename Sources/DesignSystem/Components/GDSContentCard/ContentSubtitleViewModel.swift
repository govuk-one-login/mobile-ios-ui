import UIKit

public struct ContentSubtitleViewModel {
    let title: GDSLocalisedString
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        verticalPadding: VerticalPadding? = .vertical(8),
        horizontalPadding: HorizontalPadding? = .horizontal(16)
    ) {
        self.title = title
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension ContentSubtitleViewModel: ContentItem {
    public var uiView: UIView {
        let label = UILabel()
        label.text = title.value
        label.font = DesignSystem.Font.Base.body
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "content-card-subtitle"
        return label
    }
}
