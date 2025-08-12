import UIKit

public struct ContentImageViewModel: ContentItem {
    let image: UIImage
    let contentMode: UIView.ContentMode
    
    private var aspectRatio: CGFloat {
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

extension ContentImageViewModel {
    public var uiView: UIView {
        let result = UIImageView()
        result.image = image
        result.contentMode = contentMode
        result.layer.cornerRadius = 12
        result.layer.masksToBounds = true
        result.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        result.translatesAutoresizingMaskIntoConstraints = false
        if contentMode == .scaleAspectFit {
            NSLayoutConstraint.activate([
                result.heightAnchor.constraint(equalTo: result.widthAnchor, multiplier: aspectRatio)
            ])
        }
        return result
    }
}
