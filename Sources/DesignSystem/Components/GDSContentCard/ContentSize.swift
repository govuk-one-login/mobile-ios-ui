import UIKit

extension UIContentSizeCategory {
    @MainActor
    static var sizeForDismissButton: Int {
        switch UIApplication.shared.preferredContentSizeCategory {
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            88
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            82
        case UIContentSizeCategory.accessibilityExtraLarge:
            74
        case UIContentSizeCategory.accessibilityLarge:
            66
        case UIContentSizeCategory.accessibilityMedium:
            62
        case UIContentSizeCategory.extraExtraExtraLarge:
            56
        case UIContentSizeCategory.extraExtraLarge:
            54
        case UIContentSizeCategory.extraLarge:
            52
        case UIContentSizeCategory.large:
            50
        case UIContentSizeCategory.medium:
            49
        case UIContentSizeCategory.small:
            48
        case UIContentSizeCategory.extraSmall:
            47
        case UIContentSizeCategory.unspecified:
            0
        default:
            0
        }
    }
}
