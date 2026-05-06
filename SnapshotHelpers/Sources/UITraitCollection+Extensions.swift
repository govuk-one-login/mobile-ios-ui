import UIKit

extension UITraitCollection {
    static var testingDynamicTypeTraits: [UITraitCollection] {
        [
            UITraitCollection(preferredContentSizeCategory: .large),
            UITraitCollection(preferredContentSizeCategory: .accessibilityLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        ]
    }

    static var testingUserInterfaceStyle: [UITraitCollection] {
        [
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(userInterfaceStyle: .dark)
        ]
    }
}
