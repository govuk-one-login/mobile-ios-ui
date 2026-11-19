import DesignSystem
import UIKit

@MainActor
public protocol QRScanningViewModel {
    var title: String { get }
    var instructionText: String { get }

    /// Optional title for a right-hand navigation bar button (e.g. "Cancel").
    /// When non-nil, `ScanningViewController` shows a right bar button that
    /// dismisses the screen and calls `didDismiss()`. Defaults to `nil`.
    var rightBarButtonTitle: GDSLocalisedString? { get }

    func didScan(value: String, in view: UIView) async

    /// Called after the user taps the right bar button and the screen is
    /// dismissed. Defaults to a no-op.
    func didDismiss()
}

public extension QRScanningViewModel {
    var rightBarButtonTitle: GDSLocalisedString? { nil }

    func didDismiss() {}
}
