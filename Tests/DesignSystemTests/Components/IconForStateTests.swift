@testable import DesignSystem
import Testing
import UIKit

struct IconForStateTests {
    
    @Test
    func normal() {
        let sut = IconForState(normal: .arrowUpRight)
        #expect(IconStyle.arrowUpRight.position == .trailing)
        #expect(IconStyle.arrowUpRight.accessibilityHint == "opens in your web browser")
        
        #expect(sut.forState(.normal) == .arrowUpRight)
        #expect(sut.forState(.highlighted) == .arrowUpRight)
        #expect(sut.forState(.selected) == .arrowUpRight)
        #expect(sut.forState(.focused) == .arrowUpRight)
        #expect(sut.forState(.disabled) == .arrowUpRight)
        #expect(sut.forState([.selected, .highlighted]) == .arrowUpRight)
        #expect(sut.forState([.focused, .highlighted]) == .arrowUpRight)
        
        #expect(!sut.isSelectable)
    }
    
    @Test
    func setAll() {
        let sut = IconForState(
            normal: .arrowUpRight,
            highlighted: .qrCode,
            selected: .qrCode,
            focused: .qrCode,
            disabled: .qrCode,
            selectedHighlighted: .qrCode,
            focusedHighlighted: .qrCode
        )
        
        #expect(sut.forState(.normal) == .arrowUpRight)
        #expect(sut.forState(.highlighted) == .qrCode)
        #expect(sut.forState(.selected) == .qrCode)
        #expect(sut.forState(.focused) == .qrCode)
        #expect(sut.forState(.disabled) == .qrCode)
        #expect(sut.forState([.selected, .highlighted]) == .qrCode)
        #expect(sut.forState([.focused, .highlighted]) == .qrCode)
        
        #expect(sut.isSelectable)
    }
    
    @Test func expressibleByStringLiteral() async throws {
        let sut: IconForState = "house"
        #expect(sut.forState(.normal).icon == "house")
        #expect(sut.forState(.normal).position == .trailing)
        #expect(sut.forState(.normal).accessibilityHint == nil)
    }
    
}
