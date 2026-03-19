import UIKit

/// Creates a Status Overlay component
///
/// - Parameters:
///   - iconStyle: The style of the icon to display, defaulted to `.statusOverlay`.  Ensure you update the viewModels `accessibilityLabel` if you are using a different icon
///   - warningText: Type `GDSTextViewModel`, use font `bodySemiBold`, color: `statusOverlay` and alignment `centered`
/// - remark: The position defined in IconStyle will not be respected by this component and will always be centered.
public struct GDSStatusOverlayViewModel: ContentViewModel {
    public typealias ViewType = GDSStatusOverlay
    
    let statusOverlayText: GDSTextViewModel
    let iconStyle: IconStyle?
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    
    public var accessibilityLabel: String {
        "\(NSLocalizedString(key: "voiceOverStatusOverlayPrefix", bundle: .designSystem)): \(statusOverlayText.title)"
    }
    
    public init(
        iconStyle: IconStyle? = .statusOverlay,
        statusText: GDSTextViewModel
    ) {
        self.iconStyle = iconStyle
        self.statusOverlayText = statusText
    }
}
