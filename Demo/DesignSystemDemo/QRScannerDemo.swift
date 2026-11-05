import SharedScreens
import UIKit

/// Demo view model for the `SharedScreens` QR scanner. On a successful scan it
/// shows the scanned value in an alert so the scanner can be exercised live
/// within the demo app.
@MainActor
final class QRScannerDemoViewModel: QRScanningViewModel {
    let title = "QR Scanner"
    let instructionText = "Point your camera at a QR code"

    /// Presents the scan result. Supplied by the hosting controller so the
    /// view model doesn't need its own reference to a presenter.
    private let onScan: (String) -> Void

    init(onScan: @escaping (String) -> Void) {
        self.onScan = onScan
    }

    func didScan(value: String, in view: UIView) async {
        onScan(value)
    }
}

enum QRScannerDemo {
    /// Builds a ready-to-push `ScanningViewController` wired to show scan
    /// results and setup errors via the provided `present` closure.
    @MainActor
    static func makeScreen(
        present: @escaping (UIAlertController) -> Void
    ) -> UIViewController {
        let viewModel = QRScannerDemoViewModel { value in
            let alert = UIAlertController(
                title: "Scanned",
                message: value,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert)
        }

        return ScanningViewController(
            viewModel: viewModel,
            errorHandler: { error in
                Task { @MainActor in
                    let alert = UIAlertController(
                        title: "Scanner unavailable",
                        message: Self.message(for: error),
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert)
                }
            }
        )
    }

    private static func message(for error: Error?) -> String {
        switch error as? ScanningSetupError {
        case .deviceUnavailable:
            return "No camera is available on this device."
        case .inputUnavailable:
            return "The camera could not be accessed. Check camera permissions in Settings."
        case .cannotAddInput, .cannotAddOutput:
            return "The camera could not be configured."
        case nil:
            return error?.localizedDescription ?? "An unknown error occurred."
        }
    }
}
