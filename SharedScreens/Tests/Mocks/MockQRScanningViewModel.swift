import UIKit
@testable import SharedScreens

/// Records whether a scan was delivered and forwards it to an optional handler.
final class MockQRScanningViewModel: QRScanningViewModel {
    let title: String
    let instructionText: String

    private(set) var didCallDidScan = false
    private(set) var scannedValue: String?
    private let onScan: (@MainActor (String) -> Void)?

    init(
        title: String = "QR Scanning Title",
        instructionText: String = "QR Scanning instruction area",
        onScan: (@MainActor (String) -> Void)? = nil
    ) {
        self.title = title
        self.instructionText = instructionText
        self.onScan = onScan
    }

    func didScan(value: String, in view: UIView) async {
        didCallDidScan = true
        scannedValue = value
        onScan?(value)
    }
}
