import UIKit

public final class GDSStatusOverlay: UIView, ContentView {
    private let viewModel: GDSStatusOverlayViewModel
    
    private lazy var iconView: UIImageView = {
        let font = viewModel.iconStyle?.font ?? UIFont.systemFont(ofSize: 65, weight: .thin)
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        let config = UIImage.SymbolConfiguration(font: scaledFont)
        
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
        
        stack.layer.cornerRadius = DesignSystem.CornerRadius.small
        stack.layer.masksToBounds = true
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 30, left: 8, bottom: 20, right: 8)
        
        stack.isAccessibilityElement = true
        stack.shouldGroupAccessibilityChildren = true
        stack.accessibilityLabel = viewModel.accessibilityLabel
        stack.accessibilityTraits = [.none]
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
            
            stackView.widthAnchor.constraint(equalToConstant: 200),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The view passed in should be the apps navigation controller if the component will be shown while the screens change
    /// Or the view passed in should be the top view controller, if the component is being shown on the same screen
    public func present(onView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Ensure VoiceOver announces the overlay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            UIAccessibility.post(notification: .announcement, argument: self?.viewModel.accessibilityLabel)
        }
        
        // Make view the component is being displayed on top of not interactive
        view.isUserInteractionEnabled = false
        // Hide views elements from VoiceOver
        view.accessibilityElementsHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.removeFromSuperview()
            // Make view interactive again
            view.isUserInteractionEnabled = true
            // Restore accessibility
            view.accessibilityElementsHidden = false
        }
    }
}
