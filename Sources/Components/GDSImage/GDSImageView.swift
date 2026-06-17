import UIKit

public final class GDSImageView: UIImageView, ContentView {
    public init(viewModel: GDSImageViewModel) {
        super.init(frame: .zero)
        
        self.image = viewModel.image
        self.tintColor = viewModel.imageColour
        self.contentMode = viewModel.contentMode
        if let cornerMask = viewModel.cornerMask {
            self.layer.cornerRadius = DesignSystem.CornerRadius.card
            self.layer.masksToBounds = true
            self.layer.maskedCorners = cornerMask
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if viewModel.contentMode == .scaleAspectFit {
            if let imageFixedHeight = viewModel.imageFixedHeight {
                heightAnchor.constraint(equalToConstant: imageFixedHeight).isActive = true
            } else if let imageHeightConstraint = viewModel.imageHeightConstraint {
                heightAnchor.constraint(lessThanOrEqualToConstant: imageHeightConstraint).isActive = true
            } else {
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.aspectRatio).isActive = true
            }
        }
        
        if let accessibilityLabel = viewModel.accessibilityLabel {
            self.isAccessibilityElement = true
            self.accessibilityLabel = accessibilityLabel
        }
        if let accessibilityTraits = viewModel.accessibilityTraits {
            self.accessibilityTraits = accessibilityTraits
        }
        self.accessibilityIdentifier = viewModel.accessibilityIdentifier ?? "gds-image-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
