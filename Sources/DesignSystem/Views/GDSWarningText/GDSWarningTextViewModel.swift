import UIKit

/// Creates a Warning Text component
///
/// - Parameters:
///   - iconStyle: The style of the icon to display, defaulted to `.warning`.
///   - warningText: Type `GDSTextViewModel`, use font `calloutSemiBold`
/// - remark: The position defined in IconStyle will not be respected by this component and will always be leading.
public struct GDSWarningTextViewModel: ContentViewModel {
    public typealias ViewType = GDSWarningText
    
    let iconStyle: IconStyle?
    let warningText: GDSTextViewModel
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    
    public var accessibilityLabel: String {
        "\(NSLocalizedString(key: "voiceOverWarningPrefix", bundle: .designSystem)): \(warningText.title)"
    }
    
    public init(
        iconStyle: IconStyle? = .warning,
        warningText: GDSTextViewModel
    ) {
        self.iconStyle = iconStyle
        self.warningText = warningText
    }
}
