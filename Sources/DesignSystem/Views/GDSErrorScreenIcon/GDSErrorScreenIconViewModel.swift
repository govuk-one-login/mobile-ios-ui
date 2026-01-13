import Foundation

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

public struct GDSErrorScreenIconViewModel: ContentViewModel {
    public typealias ViewType = GDSErrorScreenIcon
    
    let icon: ErrorScreenIcon
    let iconHeight: CGFloat
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    
    public var renderedIconHeight: CGFloat { iconHeight + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding }
    
    public init(
        icon: ErrorScreenIcon,
        iconHeight: CGFloat = DesignSystem.Size.GDSErrorIcon.iconTargetHeight
    ) {
        self.icon = icon
        self.iconHeight = iconHeight
    }
}
