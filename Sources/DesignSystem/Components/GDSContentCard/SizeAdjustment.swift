import UIKit

enum SizeAdjustment: CaseIterable {
    static func size(for size: UIContentSizeCategory) -> CGFloat {
        let percentage: CGFloat = switch size {
        case .extraSmall:
            80
        case .small:
            85
        case .medium:
            90
        case .large:
            100
        case .extraLarge:
            110
        case .extraExtraLarge:
            120
        case .extraExtraExtraLarge:
            135
        case .accessibilityMedium:
            160
        case .accessibilityLarge:
            190
        case .accessibilityExtraLarge:
            235
        case .accessibilityExtraExtraLarge:
            275
        case .accessibilityExtraExtraExtraLarge:
            310
        default:
            100
        }
        return percentage / 100.0
    }
}
