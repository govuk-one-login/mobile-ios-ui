@testable import DesignSystem
import Testing
import UIKit

struct GDSAttributedStringTests {
    @Test
    func initialization() {
        let sut = GDSAttributedString(
            localisedString: "this is a string",
            stringAttributes: GDSStringAttributes(
                symbol: UIImage(systemName: "exclamationmark.octagon") ?? UIImage(),
                position: .leading
            )
        ).attributedString
        
        let expectedString = NSMutableAttributedString(string: " this is a string")
        expectedString.insert(NSMutableAttributedString(
            attachment: NSTextAttachment(
                image: UIImage(systemName: "exclamationmark.octagon") ?? UIImage()
            )
        ), at: .zero)
        
        #expect(sut?.string == expectedString.string)
    }
    
    @Test
    func initialization2() {
        let sut = GDSAttributedString(
            localisedString: "this is a string",
            stringAttributes: GDSStringAttributes(
                symbol: UIImage(systemName: "exclamationmark.octagon") ?? UIImage(),
                position: .trailing
            )
        ).attributedString
        
        let expectedString = NSMutableAttributedString(string: "this is a string ")
        expectedString.append(
            NSMutableAttributedString(
                attachment: NSTextAttachment(
                    image: UIImage(systemName: "exclamationmark.octagon") ?? UIImage()
                )
            )
        )
        
        #expect(sut?.string == expectedString.string)
    }
}
