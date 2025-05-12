import Foundation
import UIKit

extension DesignSystem {
    public enum Font {
        
        // NOTE: Example mappings from existing
        public static let largeTitle: UIFont = .preferredFont(forTextStyle: .largeTitle)
        public static let largeTitleBold: UIFont = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        public static let title1: UIFont = .preferredFont(forTextStyle: .title1)
        public static let title2: UIFont = .preferredFont(forTextStyle: .title2)
        public static let title3: UIFont = .preferredFont(forTextStyle: .title3)
        public static let title3Bold: UIFont = .preferredFont(forTextStyle: .title3, weight: .bold)
        public static let headline: UIFont = .preferredFont(forTextStyle: .headline)
        public static let subheadline: UIFont = .preferredFont(forTextStyle: .subheadline)
        public static let body: UIFont = .preferredFont(forTextStyle: .body)
        public static let bodySemiBold: UIFont = .preferredFont(forTextStyle: .body, weight: .semibold)
        public static let bodyBold: UIFont = .preferredFont(forTextStyle: .body, weight: .bold)
        public static let callout: UIFont = .preferredFont(forTextStyle: .callout)
        public static let footnote: UIFont = .preferredFont(forTextStyle: .footnote)
        public static let caption1: UIFont = .preferredFont(forTextStyle: .caption1)
        public static let caption2: UIFont = .preferredFont(forTextStyle: .caption2)
        
        // NOTE: Example new font Tokens...
        public static let expiredTag: UIFont = .preferredFont(forTextStyle: .body, weight: .semibold, size: 12)
    }
    
}

extension UIFont {
    static func preferredFont(
        forTextStyle style: UIFont.TextStyle,
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
        weight: Weight
    ) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.monospacedSystemFont(
            ofSize: desc.pointSize,
            weight: weight
        )
        return metrics.scaledFont(for: font)
    }
}
