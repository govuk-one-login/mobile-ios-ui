import UIKit

public typealias GDSImageViewModel = GDSCardImageViewModel

public struct GDSCardImageViewModel: ContentViewModel {
    public typealias ViewType = GDSCardImageView
    
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

public typealias GDSImageView = GDSCardImageView

public final class GDSCardImageView: UIImageView, ContentView {
    public init(viewModel: GDSCardImageViewModel) {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
