import UIKit

public final class GDSWarningText: UIView, ContentView {
    private let viewModel: GDSWarningTextViewModel
    
    private lazy var iconView: UIImageView = {
        let font = viewModel.iconStyle?.font ?? DesignSystem.Font.Base.title1Bold
        let config = UIImage.SymbolConfiguration(font: font)
        
        let iconView = UIImageView(image: UIImage(
            systemName: viewModel.iconStyle?.icon ?? "exclamationmark.circle.fill",
            withConfiguration: config
        ))
        iconView.tintColor = DesignSystem.Color.Icons.default
        iconView.contentMode = .topLeft
        
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconView.isAccessibilityElement = true
        iconView.accessibilityIdentifier = "warning-text-icon"
        
        return iconView
    }()
    
    private lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.warningText)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = DesignSystem.Spacing.GDSWarningText.default
        stack.distribution = .fill
  
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.accessibilityLabel
        stack.accessibilityTraits = viewModel.warningText.accessibilityTraits ?? [.none]
        stack.accessibilityIdentifier = "warning-text-stack-view"
        
        return stack
    }()
    
    public init(viewModel: GDSWarningTextViewModel) {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
