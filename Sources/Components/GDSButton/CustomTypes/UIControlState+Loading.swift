import UIKit

extension UIControl.State {
    /// A custom control state representing that a `GDSButton` is performing an
    /// asynchronous action and should render its loading appearance.
    ///
    /// `UIControl.State` is an `OptionSet` backed by a raw bitmask. UIKit reserves
    /// the range `0x00FF0000` for application-defined states
    static let loading = UIControl.State(rawValue: 1 << 16)
}
