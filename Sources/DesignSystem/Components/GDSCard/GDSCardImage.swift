import UIKit

public struct GDSCardImageViewModel: ContentViewModel {
    public typealias ViewType = GDSCardImageView
    
    let image: UIImage
    let contentMode: UIView.ContentMode
    
    var aspectRatio: CGFloat {
        max(image.size.height, 1) / max(image.size.width, 1)
    }
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        image: UIImage,
        contentMode: UIView.ContentMode,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.image = image
        self.contentMode = contentMode
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

public final class GDSCardImageView: UIImageView, ContentView {
    public init(viewModel: GDSCardImageViewModel) {
        super.init(frame: .zero)
        
        self.image = viewModel.image
        self.contentMode = viewModel.contentMode
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.translatesAutoresizingMaskIntoConstraints = false
        if viewModel.contentMode == .scaleAspectFit {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.aspectRatio)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
