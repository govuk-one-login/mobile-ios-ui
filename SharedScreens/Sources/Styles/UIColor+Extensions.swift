import UIKit

extension UIColor {

    /// Initializer that uses the colour asset catalog
    /// - Parameter color: takes the GDSColours enum and uses the raw value as the colour name within the colour asset catalog
    private convenience init(_ color: GDSColours) {
        self.init(named: color.rawValue, in: .module, compatibleWith: nil)!
    }

    internal static let scannerBackground = UIColor(.scannerBackground)
    // TODO: DCMAW-6572 Review colours based on investigation from Design
    /// `DialogBackground` and `DialogText` are not part of the GDS Design System and
    /// may be replaced/updated in future; copied here to support `DialogView`.
    internal static let dialogBackground = UIColor(.dialogBackground)
    internal static let dialogText = UIColor(.dialogText)

    /// Enum for colours with raw type of `String` to allow type safe access to the asset catalog.
    ///
    /// Trimmed when copied into `SharedScreens`: only colours required by the
    /// copied screens are included here, so the bundled asset catalog only needs
    /// to contain the matching colorsets.
    enum GDSColours: String {
        case scannerBackground = "ScannerBackground"
        case dialogBackground = "DialogBackground"
        case dialogText = "DialogText"
    }
}
