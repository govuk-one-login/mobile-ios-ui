import UIKit

public final class GDSErrorIconTitle: UIView, ContentView {
    public init(viewModel: GDSErrorIconTitleViewModel) {
        super.init(frame: .zero)

        let iconView = UIImageView(
            image: UIImage(systemName: viewModel.icon.iconName)
        )
        iconView.tintColor = DesignSystem.Color.Icons.default
        iconView.contentMode = .scaleAspectFit
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: viewModel.renderedIconHeight)
            .isActive = true
     
        let titleView = GDSTextView(viewModel: viewModel.errorTitle)

        let stackView = UIStackView(arrangedSubviews: [iconView, titleView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = DesignSystem.Spacing.small
        stackView.distribution = .equalSpacing
  
        stackView.isAccessibilityElement = true
        stackView.shouldGroupAccessibilityChildren = true
        stackView.accessibilityLabel = viewModel.accessibilityLabel
        stackView.accessibilityTraits = viewModel.accessibilityTrait
        stackView.accessibilityIdentifier = "error-screen-icon-title-stack-view"
        
        
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
