import UIKit

/// Conform view controllers that inhereit from ``BaseViewController`` to this protocol to benefit
/// from setting the initial VoiceOver focus when the screen appears.
/// The focus is directed by the `viewIsAppearing` lifecycle method.
@MainActor
public protocol VoiceOverFocus {
    var initialVoiceOverView: UIView { get throws }
}

enum VoiceOverFocusError: Error {
    case notAvailable
}
