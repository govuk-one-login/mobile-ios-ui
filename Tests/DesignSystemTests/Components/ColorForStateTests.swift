import DesignSystem
import UIKit
import Testing

struct ColorForStateTests {
    
    @Test
    func normal() {
        let sut = ColorForState(normal: .black, focused: .white)
        
        #expect(sut.color(for: .normal) == .black)
        #expect(sut.color(for: .highlighted) == .black)
        #expect(sut.color(for: .selected) == .black)
        #expect(sut.color(for: .focused) == .white)
        #expect(sut.color(for: .disabled) == .black)
        #expect(sut.color(for: [.selected, .highlighted]) == .black)
        #expect(sut.color(for: [.focused, .highlighted]) == .black)
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
        
        #expect(sut.color(for: .normal) == .black)
        #expect(sut.color(for: .highlighted) == .white)
        #expect(sut.color(for: .selected) == .red)
        #expect(sut.color(for: .focused) == .green)
        #expect(sut.color(for: .disabled) == .yellow)
        #expect(sut.color(for: [.selected, .highlighted]) == .cyan)
        #expect(sut.color(for: [.focused, .highlighted]) == .orange)
    }
    
}
