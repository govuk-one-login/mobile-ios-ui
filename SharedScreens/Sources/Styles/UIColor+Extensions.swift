import UIKit

extension UIColor {

    /// Initializer that uses the colour asset catalog
    /// - Parameter color: takes the GDSColours enum and uses the raw value as the colour name within the colour asset catalog
    private convenience init(_ color: GDSColours) {
        self.init(named: color.rawValue, in: .module, compatibleWith: nil)!
    }

    internal static let scannerBackground = UIColor(.scannerBackground)

    /// Enum for colours with raw type of `String` to allow type safe access to the asset catalog.
    ///
    /// Trimmed when copied into `SharedScreens`: only colours required by the
    /// scanner screen are included here, so the bundled asset catalog only needs
    /// to contain the matching colorsets.
    enum GDSColours: String {
        case scannerBackground = "ScannerBackground"
    }
}
