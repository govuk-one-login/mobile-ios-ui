public enum ErrorScreenIcon: ContentViewModel {
    case error
    case warning
    
    public typealias ViewType = ErrorScreenIconView
    
    public var verticalPadding: VerticalPadding? {
        .vertical(DesignSystem.Spacing.default)
    }
    public var horizontalPadding: HorizontalPadding? {
        .horizontal(DesignSystem.Spacing.default)
    }
    
    var icon: String {
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
