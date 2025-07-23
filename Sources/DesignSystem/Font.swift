import Foundation
import UIKit

extension DesignSystem {
    public enum Font {
        
        // NOTE: Example mappings from existing
        public enum Base {
            public static let largeTitle: UIFont = UIFont(style: .largeTitle)
            public static let largeTitleBold: UIFont = UIFont(style: .largeTitle, weight: .bold)
            
            public static let title1: UIFont = UIFont(style: .title1)
            public static let title1Bold: UIFont = UIFont(style: .title1, weight: .bold)
            
            public static let title2: UIFont = UIFont(style: .title2)
            public static let title2Bold: UIFont = UIFont(style: .title2, weight: .bold)
            
            public static let title3: UIFont = UIFont(style: .title3)
            public static let title3Bold: UIFont = UIFont(style: .title3, weight: .bold)
            public static let title3BoldMonospaced: UIFont = UIFont(style: .title3, weight: .bold, design: .monospaced)
            
            public static let headline: UIFont = UIFont(style: .headline)
            public static let headlineBold: UIFont = UIFont(style: .headline, weight: .bold)
            
            public static let subheadline: UIFont = UIFont(style: .subheadline)
            public static let subheadlineBold: UIFont = UIFont(style: .subheadline, weight: .bold)
            
            public static let body: UIFont = UIFont(style: .body)
            public static let bodySemiBold: UIFont = UIFont(style: .body, weight: .semibold)
            public static let bodyBold: UIFont = UIFont(style: .body, weight: .bold)
            
            public static let callout: UIFont = UIFont(style: .callout)
            public static let calloutBold: UIFont = UIFont(style: .body, weight: .bold)
            
            public static let footnote: UIFont = UIFont(style: .footnote)
            public static let footnoteBold: UIFont = UIFont(style: .footnote, weight: .bold)
            
            public static let caption1: UIFont = UIFont(style: .caption1)
            public static let caption1Bold: UIFont = UIFont(style: .caption1, weight: .bold)
            
            public static let caption2: UIFont = UIFont(style: .caption2)
            public static let caption2Bold: UIFont = UIFont(style: .caption2, weight: .bold)
            
        }
    }
}

extension UIFont {
    public convenience init(
        style: TextStyle,
        weight: Weight = .regular,
        design: UIFontDescriptor.SystemDesign = .default,
        monospaced: Bool = false
    ) {
        guard let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
            .withDesign(design) else {
            preconditionFailure("Could not find a matching font")
        }
        self.init(descriptor: descriptor, size: 0)
    }
}
