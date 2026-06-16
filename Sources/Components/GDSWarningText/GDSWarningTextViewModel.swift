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
    let iconSpacing: CGFloat
    
    public var accessibilityIdentifier: String?
    public var accessibilityTraits: UIAccessibilityTraits?
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public var accessibilityLabel: String {
        let iconAccessibilityHint = iconStyle?.accessibilityHint ?? NSLocalizedString(
            key: "voiceOverWarningPrefix",
            bundle: .designSystem
        )
        
        return "\(iconAccessibilityHint): \(warningText.title)"
    }
    
    public init(
        iconStyle: IconStyle? = .warning,
        warningText: GDSTextViewModel,
        iconSpacing: CGFloat = DesignSystem.Spacing.GDSWarningText.default,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default),
        horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    ) {
        self.iconStyle = iconStyle
        self.warningText = warningText
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.iconSpacing = iconSpacing
    }
}
