import Foundation
import UIKit

public typealias Attributes = [(String, [NSAttributedString.Key: Any])]

public struct GDSStringAttributes {
    public let symbol: UIImage?
    public let position: SymbolPosition
    public let attributes: Attributes?
    
    public init(
        symbol: UIImage? = nil,
        position: SymbolPosition = .trailing,
        attributes: Attributes? = nil
    ) {
        self.symbol = symbol
        self.position = position
        self.attributes = attributes
    }
}

extension GDSStringAttributes: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (String, [NSAttributedString.Key: Any])...) {
        self.symbol = nil
        self.position = .trailing
        self.attributes = elements
    }
}

public struct GDSLocalisedString {
    public let stringKey: String
    public let variableKeys: [String]
    public let stringAttributes: GDSStringAttributes?
    let bundle: Bundle
    
    public var value: String {
        NSLocalizedString(key: stringKey,
                          parameters: variableKeys.map { NSLocalizedString(key: $0, bundle: bundle) },
                          bundle: bundle)
    }
    
    public var attributedValue: NSAttributedString? {
        guard let stringAttributes else { return nil }
        return GDSAttributedString(localisedString: value,
                                   stringAttributes: stringAttributes).attributedString
    }
    
    public init(stringKey: String,
                _ variableKeys: String...,
                stringAttributes: GDSStringAttributes? = nil,
                bundle: Bundle = .main) {
        self.stringKey = stringKey
        self.variableKeys = variableKeys
        self.stringAttributes = stringAttributes
        self.bundle = bundle
    }
    
    public init(stringKey: String,
                variableKeys: [String],
                stringAttributes: GDSStringAttributes? = nil,
                bundle: Bundle = .main) {
        self.stringKey = stringKey
        self.variableKeys = variableKeys
        self.stringAttributes = stringAttributes
        self.bundle = bundle
    }
}

extension GDSLocalisedString: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.stringKey = value
        self.variableKeys = []
        self.stringAttributes = nil
        self.bundle = .main
    }
    
    public init(stringLiteral value: StringLiteralType,
                stringAttributes: GDSStringAttributes?) {
        self.stringKey = value
        self.variableKeys = []
        self.stringAttributes = stringAttributes
        self.bundle = .main
    }
}

extension GDSLocalisedString: CustomStringConvertible {
    public var description: String {
        value
    }
}

extension GDSLocalisedString: Equatable {
    public static func == (lhs: GDSLocalisedString, rhs: GDSLocalisedString) -> Bool {
        lhs.stringKey == rhs.stringKey &&
        lhs.variableKeys == rhs.variableKeys &&
        lhs.bundle == rhs.bundle &&
        compare(lhs: lhs.stringAttributes?.attributes, to: rhs.stringAttributes?.attributes)
    }
    
    private static func compare(lhs: Attributes?, to rhs: Attributes?) -> Bool {
        let isSameLength = lhs?.count == rhs?.count
        let zipped = zip(lhs ?? [], rhs ?? [])
        return zipped
            .allSatisfy { lhsAttribute, rhsAttribute in
                lhsAttribute.0 == rhsAttribute.0
            } && isSameLength
    }
}
