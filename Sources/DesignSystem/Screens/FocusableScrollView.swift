import UIKit

/// A scroll view that can receive focus via Full Keyboard Access,
/// allowing users to scroll content using arrow keys.
final class FocusableScrollView: UIScrollView {
    override var canBecomeFocused: Bool { true }
}
