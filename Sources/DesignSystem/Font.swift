import Foundation
import UIKit

extension DesignSystem {
    public enum Font {
        
        // NOTE: Example mappings from existing
        public enum Base {
            public static let largeTitle: UIFont = UIFont(.largeTitle)
            public static let largeTitleBold: UIFont = UIFont(.largeTitle, weight: .bold)
            
            public static let title1: UIFont = UIFont(.title1)
            public static let title1Bold: UIFont = UIFont(.title1, weight: .bold)
            
            public static let title2: UIFont = UIFont(.title2)
            public static let title2Bold: UIFont = UIFont(.title2, weight: .bold)
            
            public static let title3: UIFont = UIFont(.title3)
            public static let title3SemiBold: UIFont = UIFont(.title3, weight: .semibold)
            public static let title3Bold: UIFont = UIFont(.title3, weight: .bold)
            public static let title3BoldMonospaced: UIFont = UIFont(.title3, weight: .bold, design: .monospaced)
            
            public static let headline: UIFont = UIFont(.headline)
            public static let headlineBold: UIFont = UIFont(.headline, weight: .bold)
            
            public static let subheadline: UIFont = UIFont(.subheadline)
            public static let subheadlineSemiBold: UIFont = UIFont(.subheadline, weight: .semibold)
            public static let subheadlineBold: UIFont = UIFont(.subheadline, weight: .bold)
            
            public static let body: UIFont = UIFont(.body)
            public static let bodySemiBold: UIFont = UIFont(.body, weight: .semibold)
            public static let bodyBold: UIFont = UIFont(.body, weight: .bold)
            public static let bodyBoldMonospaced: UIFont = UIFont(.body, weight: .bold, design: .monospaced)
            
            public static let callout: UIFont = UIFont(.callout)
            public static let calloutSemiBold: UIFont = UIFont(.callout, weight: .semibold)
            public static let calloutBold: UIFont = UIFont(.body, weight: .bold)
            
            public static let footnote: UIFont = UIFont(.footnote)
            public static let footnoteSemiBold: UIFont = UIFont(.footnote, weight: .semibold)
            public static let footnoteBold: UIFont = UIFont(.footnote, weight: .bold)
            
            public static let caption1: UIFont = UIFont(.caption1)
            public static let caption1Medium: UIFont = UIFont(.caption1, weight: .medium)
            public static let caption1Bold: UIFont = UIFont(.caption1, weight: .bold)
            
            public static let caption2: UIFont = UIFont(.caption2)
            public static let caption2SemiBold: UIFont = UIFont(.caption2, weight: .semibold)
            public static let caption2Bold: UIFont = UIFont(.caption2, weight: .bold)
            
        }
    }
}

extension UIFont {
    public convenience init(
        _ style: TextStyle,
        weight: Weight = .regular,
        design: UIFontDescriptor.SystemDesign = .default
    ) {
        guard let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
            .withDesign(design) else {
            preconditionFailure("Could not find a matching font")
        }
        self.init(descriptor: descriptor, size: 0)
    }
}
