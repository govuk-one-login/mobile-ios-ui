import UIKit

public final class GDSErrorScreenIcon: UIImageView, ContentView {
    
    public init(viewModel: GDSErrorScreenIconViewModel) {
        super.init(frame: .zero)
        
        let image = UIImage(systemName: viewModel.icon.iconName)
        self.image = image
        self.tintColor = DesignSystem.Color.Icons.default
        self.contentMode = .scaleAspectFit
        self.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: 107).isActive = true
        
        isAccessibilityElement = true
        accessibilityLabel = viewModel.icon.voiceoverPrefix
        
        accessibilityIdentifier = "error-screen-icon"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
