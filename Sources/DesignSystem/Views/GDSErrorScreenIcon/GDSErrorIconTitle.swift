import UIKit

public final class GDSErrorIconTitle: UIView, ContentView {
    private let viewModel: GDSErrorIconTitleViewModel
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(
            image: UIImage(systemName: viewModel.icon.iconName)
        )
        iconView.tintColor = DesignSystem.Color.Icons.default
        iconView.contentMode = .scaleAspectFit
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconView.isAccessibilityElement = false
        iconView.accessibilityIdentifier = "error-screen-icon"
        iconView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: viewModel.renderedIconHeight)
            .isActive = true
        
        return iconView
    }()
    
    private lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.errorTitle)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = DesignSystem.Spacing.small
        stack.distribution = .equalSpacing
  
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.accessibilityLabel
        stack.accessibilityTraits = viewModel.accessibilityTrait
        stack.accessibilityIdentifier = "error-screen-icon-title-stack-view"
        
        return stack
    }()
    
    public init(viewModel: GDSErrorIconTitleViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
