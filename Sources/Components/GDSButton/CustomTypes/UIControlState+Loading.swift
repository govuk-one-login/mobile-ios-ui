import UIKit

extension UIControl.State {
    /// A custom control state representing that a `GDSButton` is performing an
    /// asynchronous action and should render its loading appearance.
    ///
    /// `UIControl.State` is an `OptionSet` backed by a raw bitmask. UIKit reserves
    /// the range `0x00FF0000` for application-defined states (see the documentation
    /// for `UIControl.State.application`), so a custom bit must live inside that
    /// window to avoid colliding with system states such as `.highlighted`,
    /// `.disabled`, `.selected` and `.focused`. `1 << 16` (`0x00010000`) is the
    /// lowest bit in that reserved range, making it a safe, conventional choice.
    static let loading = UIControl.State(rawValue: 1 << 16)
}
