public enum ErrorScreenIcon {
    case error
    case warning
    case update
    
    var iconName: String {
        switch self {
        case .error, .warning:
            "exclamationmark.circle"
        case .update:
            "exclamationmark.arrow.circlepath"
        }
    }
    
    var voiceoverPrefix: String {
        switch self {
        case .error, .update:
            NSLocalizedString(key: "voiceOverErrorPrefix", bundle: .designSystem)
        case .warning:
            NSLocalizedString(key: "voiceOverWarningPrefix", bundle: .designSystem)
        }
    }
}
