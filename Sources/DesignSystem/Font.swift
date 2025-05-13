import Foundation
import UIKit

extension DesignSystem {
    public enum Font {
        
        // NOTE: Example mappings from existing
        public static let largeTitle: UIFont = .preferredFont(for: .largeTitle)
        public static let largeTitleBold: UIFont = .preferredFont(for: .largeTitle, weight: .bold)
        public static let title1: UIFont = .preferredFont(for: .title1)
        public static let title2: UIFont = .preferredFont(for: .title2)
        public static let title3: UIFont = .preferredFont(for: .title3)
        public static let title3Bold: UIFont = .preferredFont(for: .title3, weight: .bold)
        public static let headline: UIFont = .preferredFont(for: .headline)
        public static let subheadline: UIFont = .preferredFont(for: .subheadline)
        public static let body: UIFont = .preferredFont(for: .body)
        public static let bodySemiBold: UIFont = .preferredFont(for: .body, weight: .semibold)
        public static let bodyBold: UIFont = .preferredFont(for: .body, weight: .bold)
        public static let callout: UIFont = .preferredFont(for: .callout)
        public static let footnote: UIFont = .preferredFont(for: .footnote)
        public static let caption1: UIFont = .preferredFont(for: .caption1)
        public static let caption2: UIFont = .preferredFont(for: .caption2)
        
        // NOTE: Example new font Tokens...
        public static let expiredTag: UIFont = .preferredFont(for: .caption1, weight: .bold, size: 12)
        public static let primaryLabelLarge: UIFont = .preferredMonospacedFont(for: .title2, weight: .bold, size: 20)
    }
}

extension UIFont {
    static func preferredFont(
        for style: UIFont.TextStyle,
        weight: Weight = .regular,
        size: CGFloat? = nil
    ) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let defaultSize = descriptor.pointSize
        let fontToScale = UIFont.systemFont(ofSize: size ?? defaultSize, weight: weight)
        return metrics.scaledFont(for: fontToScale)
    }
    
    // NOTE: Can be made private once we have better font tokens for usage
    public static func preferredMonospacedFont(
        for style: TextStyle,
        weight: Weight,
        size: CGFloat? = nil
    ) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        
        var sizeToUse: CGFloat = desc.pointSize
        if let size = size {
            sizeToUse = size
        }
        
        let font = UIFont.monospacedSystemFont(
            ofSize: sizeToUse,
            weight: weight
        )
        return metrics.scaledFont(for: font)
    }
}
