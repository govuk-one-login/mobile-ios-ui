import DesignSystem
import UIKit
import Testing

struct IconForStateTests {
    
    @Test
    func normal() {
        let sut = IconForState(normal: .arrowUpRight)
        #expect(IconStyle.arrowUpRight.position == .trailing)
        #expect(IconStyle.arrowUpRight.accessibilityHint == "opens in your web browser")
        
        #expect(sut.icon(for: .normal) == .arrowUpRight)
        #expect(sut.icon(for: .highlighted) == .arrowUpRight)
        #expect(sut.icon(for: .selected) == .arrowUpRight)
        #expect(sut.icon(for: .focused) == .arrowUpRight)
        #expect(sut.icon(for: .disabled) == .arrowUpRight)
        #expect(sut.icon(for: [.selected, .highlighted]) == .arrowUpRight)
        #expect(sut.icon(for: [.focused, .highlighted]) == .arrowUpRight)
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
        
        #expect(sut.icon(for: .normal) == .arrowUpRight)
        #expect(sut.icon(for: .highlighted) == .qrCode)
        #expect(sut.icon(for: .selected) == .qrCode)
        #expect(sut.icon(for: .focused) == .qrCode)
        #expect(sut.icon(for: .disabled) == .qrCode)
        #expect(sut.icon(for: [.selected, .highlighted]) == .qrCode)
        #expect(sut.icon(for: [.focused, .highlighted]) == .qrCode)
    }
    
}
