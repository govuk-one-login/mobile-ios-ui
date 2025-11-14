import UIKit

@available(*, deprecated, renamed: "GDSImageViewModel", message: "to be removed October 2025")
public typealias GDSCardImageViewModel = GDSImageViewModel

public struct GDSImageViewModel: ContentViewModel {
    public typealias ViewType = GDSImageView
    
    let image: UIImage
    let imageColour: UIColor?
    let contentMode: UIView.ContentMode
    let imageHeightConstraint: CGFloat?
//    let imageWidthConstraint: CGFloat?
    let cornerMask: CACornerMask?
    let accessibilityLabel: String?
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    var aspectRatio: CGFloat {
        max(image.size.height, 1) / max(image.size.width, 1)
    }
    
    public init(
        image: UIImage,
        imageColour: UIColor? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        imageHeightConstraint: CGFloat? = nil,
        cornerMask: CACornerMask? = nil,
        accessibilityLabel: String? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.image = image
        self.imageColour = imageColour
        self.contentMode = contentMode
        self.imageHeightConstraint = imageHeightConstraint
        self.cornerMask = cornerMask
        self.accessibilityLabel = accessibilityLabel
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

@available(*, deprecated, renamed: "GDSImageView", message: "to be removed October 2025")
public typealias GDSCardImageView = GDSImageView

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
            if let imageHeightConstraint = viewModel.imageHeightConstraint {
                heightAnchor.constraint(lessThanOrEqualToConstant: imageHeightConstraint).isActive = true
            } else {
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.aspectRatio).isActive = true
            }
        }
        
        if let accessibilityLabel = viewModel.accessibilityLabel {
            self.isAccessibilityElement = true
            self.accessibilityLabel = accessibilityLabel
        }
        
        self.accessibilityIdentifier = "gds-image-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
