import UIKit

public struct GDSSymbolViewModel: ContentViewModel {
    public typealias ViewType = GDSSymbolView
    
    let image: UIImage
    let imageColour: UIColor
    let accessibilityLabel: String?
    let contentMode: UIView.ContentMode
    let imageHeightConstraint: CGFloat?
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        image: UIImage,
        imageColour: UIColor,
        accessibilityLabel: String? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        imageHeightConstraint: CGFloat? = nil,
        verticalPadding: VerticalPadding? = nil,
        horizontalPadding: HorizontalPadding? = nil
    ) {
        self.image = image
        self.imageColour = imageColour
        self.accessibilityLabel = accessibilityLabel
        self.contentMode = contentMode
        self.imageHeightConstraint = imageHeightConstraint

        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

public final class GDSSymbolView: UIImageView, ContentView {
    public init(viewModel: GDSSymbolViewModel) {
        super.init(frame: .zero)
        
        self.image = viewModel.image
        self.tintColor = viewModel.imageColour
        if let accessibilityLabel = viewModel.accessibilityLabel {
            self.isAccessibilityElement = true
            self.accessibilityLabel = accessibilityLabel
        }
        self.contentMode = viewModel.contentMode
        
        var heightConstraint: CGFloat {
            if let value = viewModel.imageHeightConstraint {
                /// The minimum height constraint for the image view configured plus an 11pt buffer
                value + 11
            } else {
                /// The default minimum height constraint for the image view is 55pts
                55
            }
        }
        
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: heightConstraint).isActive = true
        self.accessibilityIdentifier = "gds-symbol-view"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
