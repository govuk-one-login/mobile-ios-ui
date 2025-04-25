import UIKit

extension UIColor {
    /// Gets the color set for the dark appearance trait
    var darkColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }
    
    /// Gets the color set for the dark appearance trait
    var lightColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }
    
    /// Convenience initialiser to set colors for both appearance traits
    /// - Parameters:
    ///   - light:  The color to use for light appearance trait
    ///   - dark: The color to use for dark appearance trait
    public convenience init(
        light: UIColor,
        dark: UIColor
    ) {
        self.init { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    /// Generate a UIColor from a hex string. Note: Must include the # e.g. #FFFFFF for white.
    /// - Parameter hex: The hex string representation of the color
    /// - Parameter alpha: The alpha value from 0 to 1
    /// - Returns: A UIColor
    public static func fromHex(
        _ hex: String,
        alpha: CGFloat = 1.0
    ) -> UIColor {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        
        // Strip out the # if present
        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                red = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                green = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                blue = CGFloat(hexNumber & 0x0000FF) / 255
                
                return UIColor(
                    red: red,
                    green: green,
                    blue: blue,
                    alpha: alpha
                )
            }
        }
        return .label // Fallback
    }
}
