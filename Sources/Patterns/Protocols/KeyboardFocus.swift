import UIKit

/// Conform a ``GDSScreenViewModel`` to this protocol to direct keyboard /
/// Full Keyboard Access focus to a specific view as focus enters the screen.
/// The focus is directed by ``GDSScreen``'s `preferredFocusEnvironments`.
///
/// The target is named by accessibility identifier rather than by view, because
/// ``GDSScreen`` builds its views lazily from the view model's content - the
/// views do not exist when the view model is constructed.
@MainActor
public protocol KeyboardFocus {
    /// Accessibility identifier of the view focus should be directed to,
    /// or `nil` to use the system's default focus order.
    var preferredFocusAccessibilityIdentifier: String? { get }
}
