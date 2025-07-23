import UIKit

extension AttributedString {
    static let objectReplacementCharacter = "\u{FFFC}"

    static let nonBreakingSpace: AttributedString = "\u{00A0}"
    
    func addIcon(iconStyle: IconStyle?) -> AttributedString? {
        guard let iconStyle else { return nil }
        
        let textAttachment = NSTextAttachment(image: UIImage(systemName: iconStyle.icon) ?? UIImage())
        let iconAttString = AttributedString(
            Self.objectReplacementCharacter,
            attributes: AttributeContainer.attachment(textAttachment)
        )
        
        switch iconStyle.position {
        case .leading:
            return iconAttString + .nonBreakingSpace + self
        case .trailing:
            return self + .nonBreakingSpace + iconAttString
        }
    }
}

// silence sendable warnings on text attachment
extension NSTextAttachment: @retroactive @unchecked Sendable { }
