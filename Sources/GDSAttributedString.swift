import Foundation
import UIKit

/// `GDSAttributedString` is a custom type to help styling `GDSLocalisedString`.
/// It is an internal type and is not used directly but rather it is used through a `GDSLocalisedString`.
/// - `localisedString` (type: `String`)
/// - `attributes` (type:`Attributes`)
/// - `attributedString` (type: `NSAttributedString`)
/// The computed property `attributedString` uses both stored properties `localisedString` and `attributes`
/// to return an `NSAttributedString`.Thanks to the initialisers available in `GDSLocalisedString` you can set attributes
/// along with the strings you wish to apply these attributes to like in this example below.
/// ```swift
/// var body: GDSLocalisedString = .init(
/// stringLiteral: "This text is bold. This text is not.",
/// attributes: [("This text is bold", [.font: UIFont.bodyBold])])
/// ```
struct GDSAttributedString {
    static let nonBreakingSpace: String = "\u{00A0}"
    
    let localisedString: String
    let stringAttributes: GDSStringAttributes
    
    var attributedString: NSAttributedString? {
        if stringAttributes.symbol == nil {
            guard let attributes = stringAttributes.attributes, !attributes.isEmpty else {
                return nil
            }
        }
        
        let mutableAttributeString: NSMutableAttributedString
        
        if let symbol = stringAttributes.symbol {
            let sfSymbol = NSMutableAttributedString(attachment: NSTextAttachment(image: symbol))
            
            switch stringAttributes.position {
            case .leading:
                let attrString = NSMutableAttributedString(string: Self.nonBreakingSpace + localisedString)
                attrString.insert(sfSymbol, at: .zero)
                mutableAttributeString = attrString
            case .trailing:
                let attrString = NSMutableAttributedString(string: localisedString + Self.nonBreakingSpace)
                attrString.append(sfSymbol)
                mutableAttributeString = attrString
            }
        } else {
            mutableAttributeString = NSMutableAttributedString(string: localisedString)
        }
        
        if let attributes = stringAttributes.attributes {
            attributes.forEach {
                let range = NSString(string: mutableAttributeString.string)
                    .range(of: $0, options: .caseInsensitive)
                mutableAttributeString.addAttributes($1, range: range)
            }
        }
        
        return mutableAttributeString
    }
}
