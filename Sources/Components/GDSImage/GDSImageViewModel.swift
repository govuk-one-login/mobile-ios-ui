import UIKit

public struct GDSImageViewModel: ContentViewModel {
    public typealias ViewType = GDSImageView
    
    let image: UIImage
    let imageColour: UIColor?
    let contentMode: UIView.ContentMode
    let imageHeightConstraint: CGFloat?
    let imageFixedHeight: CGFloat?
    let cornerMask: CACornerMask?
    let accessibilityLabel: String?
    
    public let accessibilityIdentifier: String?
    public let accessibilityTraits: UIAccessibilityTraits?
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
        imageFixedHeight: CGFloat? = nil,
        cornerMask: CACornerMask? = nil,
        accessibilityLabel: String? = nil,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.image = image
        self.imageColour = imageColour
        self.contentMode = contentMode
        self.imageHeightConstraint = imageHeightConstraint
        self.imageFixedHeight = imageFixedHeight
        self.cornerMask = cornerMask
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
