import UIKit

public final class GDSStatusOverlay: UIView, ContentView {
    private let viewModel: GDSStatusOverlayViewModel
    
    private lazy var iconView: UIImageView = {
        let font = viewModel.iconStyle?.font ?? DesignSystem.Font.Base.bodySemiBold
        let config = UIImage.SymbolConfiguration(font: font)
        
        let iconView = UIImageView(image: UIImage(
            systemName: viewModel.iconStyle?.icon ?? "checkmark.circle",
            withConfiguration: config
        ))
        iconView.tintColor = viewModel.iconStyle?.colour ?? DesignSystem.Color.Icons.statusOverlay
        iconView.contentMode = .center
        
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iconView.isAccessibilityElement = true
        iconView.accessibilityIdentifier = "status-overlay-icon"
        
        return iconView
    }()
    

    private lazy var titleView: GDSTextView = {
        GDSTextView(viewModel: viewModel.statusOverlayText)
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleView])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = DesignSystem.Spacing.default
        stack.backgroundColor = DesignSystem.Color.Backgrounds.statusOverlay
        
        stack.layer.cornerRadius = DesignSystem.CornerRadius.default // TODO: confirm
        stack.layer.masksToBounds = true
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.accessibilityLabel
        stack.accessibilityTraits = [.none] // TODO: confirm
        stack.accessibilityIdentifier = "status-overlay-stack-view"
        
        return stack
    }()
    
    public init(viewModel: GDSStatusOverlayViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.widthAnchor.constraint(equalToConstant: 170),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
