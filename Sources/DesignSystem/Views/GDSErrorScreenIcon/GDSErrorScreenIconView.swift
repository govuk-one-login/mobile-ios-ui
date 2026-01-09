import UIKit

public final class ErrorScreenIconView: UIImageView, ContentView {
    
    public init(viewModel: ErrorScreenIcon) {
        super.init(frame: .zero)
        
        let image = UIImage(systemName: viewModel.icon)
        self.image = image
        self.tintColor = DesignSystem.Color.Icons.default
        self.contentMode = .scaleAspectFit
        
        heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        isAccessibilityElement = true
        accessibilityLabel = viewModel.voiceoverPrefix
        
        accessibilityIdentifier = "error-screen-icon"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
