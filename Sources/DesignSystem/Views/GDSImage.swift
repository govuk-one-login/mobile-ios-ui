import UIKit

public typealias GDSCardImageViewModel = GDSImageViewModel

public struct GDSImageViewModel: ContentViewModel {
    public typealias ViewType = GDSImageView
    
    let image: UIImage
    let accessibilityLabel: String?
    let contentMode: UIView.ContentMode
    let cornerMask: CACornerMask?
    
    var aspectRatio: CGFloat {
        max(image.size.height, 1) / max(image.size.width, 1)
    }
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        image: UIImage,
        accessibilityLabel: String? = nil,
        contentMode: UIView.ContentMode,
        cornerMask: CACornerMask? = [.layerMinXMinYCorner, .layerMaxXMinYCorner],
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.image = image
        self.accessibilityLabel = accessibilityLabel
        self.contentMode = contentMode
        self.cornerMask = cornerMask
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

public typealias GDSCardImageView = GDSImageView

public final class GDSImageView: UIImageView, ContentView {
    public init(viewModel: GDSImageViewModel) {
        super.init(frame: .zero)
        
        self.image = viewModel.image
        self.contentMode = viewModel.contentMode
        if let cornerMask = viewModel.cornerMask {
            self.layer.cornerRadius = DesignSystem.CornerRadius.card
            self.layer.masksToBounds = true
            self.layer.maskedCorners = cornerMask
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        if viewModel.contentMode == .scaleAspectFit {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.aspectRatio)
            ])
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
