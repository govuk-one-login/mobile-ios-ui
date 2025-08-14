import UIKit

extension UIContentSizeCategory {
    @MainActor
    static var sizeForDismissButton: Int {
        switch UIApplication.shared.preferredContentSizeCategory {
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            100
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            90
        case UIContentSizeCategory.accessibilityExtraLarge:
            78
        case UIContentSizeCategory.accessibilityLarge:
            66
        case UIContentSizeCategory.accessibilityMedium:
            58
        case UIContentSizeCategory.extraExtraExtraLarge:
            48
        case UIContentSizeCategory.extraExtraLarge:
            46
        case UIContentSizeCategory.extraLarge:
            44
        case UIContentSizeCategory.large:
            42
        case UIContentSizeCategory.medium:
            42
        case UIContentSizeCategory.small:
            40
        case UIContentSizeCategory.extraSmall:
            35
        case UIContentSizeCategory.unspecified:
            0
        default:
            0
        }
    }
}
