import Foundation
import UIKit

public enum ErrorScreenIcon {
    case error
    case warning
    
    var iconName: String {
        switch self {
        case .error, .warning:
            "exclamationmark.circle"
        }
    }
    
    var voiceoverPrefix: String {
        switch self {
        case .error:
            NSLocalizedString(key: "voiceOverErrorPrefix", bundle: .designSystem)
        case .warning:
            NSLocalizedString(key: "voiceOverWarningPrefix", bundle: .designSystem)
        }
    }
}

public struct GDSErrorIconTitleViewModel: ContentViewModel {
    public typealias ViewType = GDSErrorIconTitle
    
    let icon: ErrorScreenIcon
    let errorTitle: GDSTextViewModel
    let iconHeight: CGFloat
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)

    public var renderedIconHeight: CGFloat {
        iconHeight + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding
    }
    
    var accessibilityLabel: String {
        "\(icon.voiceoverPrefix): \(errorTitle.title.description)"
    }
    
    var accessibilityTrait: UIAccessibilityTraits {
        errorTitle.isHeaderDisabled == true ? [] : [.header]
    }
    
    public init(
        icon: ErrorScreenIcon,
        errorTitle: GDSTextViewModel,
        iconHeight: CGFloat = DesignSystem.Size.GDSErrorIcon.iconTargetHeight
    ) {
        self.icon = icon
        self.errorTitle = errorTitle
        self.iconHeight = iconHeight
    }
}
