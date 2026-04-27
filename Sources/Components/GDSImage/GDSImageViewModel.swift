import UIKit

public struct GDSImageViewModel: ContentViewModel {
    public typealias ViewType = GDSImageView
    
    let image: UIImage
    let imageColour: UIColor?
    let contentMode: UIView.ContentMode
    let imageHeightConstraint: CGFloat?
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
