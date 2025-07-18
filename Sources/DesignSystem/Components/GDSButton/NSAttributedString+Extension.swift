import UIKit

extension NSAttributedString {
    public static var nonBreakingSpace: NSAttributedString {
        .init(string: "\u{00A0}")
    }
    
    public convenience init(_ strings: [NSAttributedString]) {
        self.init(attributedString: strings
            .reduce(into: NSMutableAttributedString()) {
                $0.append($1)
            }
        )
    }
    
    public static func + (_ lhs: NSAttributedString, _ rhs: NSAttributedString) -> NSAttributedString {
        NSAttributedString([lhs, rhs])
    }
}
