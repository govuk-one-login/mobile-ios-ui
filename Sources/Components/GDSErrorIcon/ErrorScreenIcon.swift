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
