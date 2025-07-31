@testable import DesignSystem
import Testing
import UIKit

struct ColorForStateTests {
    
    @Test
    func normal() {
        let sut = ColorForState(normal: .black, focused: .white)
        
        #expect(sut.forState(.normal) == .black)
        #expect(sut.forState(.highlighted) == .black)
        #expect(sut.forState(.selected) == .black)
        #expect(sut.forState(.focused) == .white)
        #expect(sut.forState(.disabled) == .black)
        #expect(sut.forState([.selected, .focused]) == .white)
        #expect(sut.forState([.selected, .highlighted]) == .black)
        #expect(sut.forState([.focused, .highlighted]) == .black)
        
        #expect(!sut.isSelectable)
    }
    
    @Test
    func setAll() {
        let sut = ColorForState(
            normal: .black,
            highlighted: .white,
            selected: .red,
            focused: .green,
            disabled: .yellow,
            selectedHighlighted: .cyan,
            focusedHighlighted: .orange
        )
        
        #expect(sut.forState(.normal) == .black)
        #expect(sut.forState(.highlighted) == .white)
        #expect(sut.forState(.selected) == .red)
        #expect(sut.forState(.focused) == .green)
        #expect(sut.forState(.disabled) == .yellow)
        #expect(sut.forState([.selected, .focused]) == .green)
        #expect(sut.forState([.selected, .highlighted]) == .cyan)
        #expect(sut.forState([.focused, .highlighted]) == .orange)
        
        #expect(sut.isSelectable)
    }
    
}
