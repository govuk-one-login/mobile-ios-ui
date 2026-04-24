import UIKit

@available(*, deprecated, renamed: "GDSTextView", message: "to be removed October 2025")
public typealias GDSCardTextView = GDSTextView

public final class GDSTextView: UILabel, ContentView {
    public init(viewModel: GDSTextViewModel) {
        super.init(frame: .zero)
        
        self.font = viewModel.titleFont
        self.textColor = viewModel.textColor
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
        self.accessibilityIdentifier = "gds-text-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
