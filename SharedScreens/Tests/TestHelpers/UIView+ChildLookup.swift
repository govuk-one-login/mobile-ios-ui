import UIKit

extension UIView {
    private func findChildView(byAccessibilityIdentifier identifier: String) -> UIView? {
        if let match = subviews.first(where: { $0.accessibilityIdentifier == identifier }) {
            return match
        }
        return subviews.lazy
            .compactMap { $0.findChildView(byAccessibilityIdentifier: identifier) }
            .first
    }

    subscript<T: UIView>(child identifier: String) -> T? {
        findChildView(byAccessibilityIdentifier: identifier) as? T
    }
}
