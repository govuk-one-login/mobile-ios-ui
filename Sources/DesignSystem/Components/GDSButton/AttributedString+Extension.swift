import UIKit

extension AttributedString {
    public static var nonBreakingSpace: AttributedString {
        .init("\u{00A0}")
    }
    
    public func addIcon(iconStyle: IconStyle?) -> AttributedString? {
        guard let iconStyle else { return nil }
        
        let textAttachment = NSTextAttachment(image: UIImage(systemName: iconStyle.icon) ?? UIImage())
        let iconAttString = AttributedString(
            "\(UnicodeScalar(NSTextAttachment.character)!)",
            attributes: AttributeContainer.attachment(textAttachment)
        )
        
        switch iconStyle.position {
        case .beforeTitle:
            return iconAttString + .nonBreakingSpace + self
        case .afterTitle:
            return self + .nonBreakingSpace + iconAttString
        }
    }
}

// silence sendable warnings on text attachment
extension NSTextAttachment: @retroactive @unchecked Sendable { }
