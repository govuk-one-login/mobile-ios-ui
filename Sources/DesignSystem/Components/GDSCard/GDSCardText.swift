import UIKit

public struct GDSCardTextViewModel: ContentViewModel {
    public typealias ViewType = GDSCardTextView
    
    let title: GDSLocalisedString
    let titleFont: UIFont
    let alignment: NSTextAlignment
    let accessibilityTraits: UIAccessibilityTraits?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.body,
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

public final class GDSCardTextView: UILabel, ContentView {
    public init(viewModel: GDSCardTextViewModel) {
        super.init(frame: .zero)
        
        self.font = viewModel.titleFont
        self.textColor = DesignSystem.Color.Text.primary
        if let attributedTitle = viewModel.title.attributedValue {
            self.attributedText = attributedTitle
        } else {
            self.text = viewModel.title.value
        }
        self.textAlignment = viewModel.alignment
        self.numberOfLines = .zero
        self.lineBreakMode = .byWordWrapping
        self.adjustsFontForContentSizeCategory = true
        if let accessibilityTraits = viewModel.accessibilityTraits {
            self.accessibilityTraits = accessibilityTraits
        }
        self.accessibilityIdentifier = "content-card-label"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
