import UIKit

extension UITraitCollection {
    public static var testingDynamicTypeTraits: [UITraitCollection] {
        [
            UITraitCollection(preferredContentSizeCategory: .large),
            UITraitCollection(preferredContentSizeCategory: .accessibilityLarge),
            UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        ]
    }

    public static var testingUserInterfaceStyle: [UITraitCollection] {
        [
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(userInterfaceStyle: .dark)
        ]
    }
}
