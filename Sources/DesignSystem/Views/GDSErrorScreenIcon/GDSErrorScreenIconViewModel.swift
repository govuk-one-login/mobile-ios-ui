public enum ErrorScreenIcon: String {
    case error
    case warning
    
    var iconImage: String {
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
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    
    public init(
        icon: ErrorScreenIcon
    ) {
        self.icon = icon
    }
}
