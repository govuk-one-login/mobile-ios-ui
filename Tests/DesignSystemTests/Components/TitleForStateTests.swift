import DesignSystem
import UIKit
import Testing

struct TitleForStateTests {
    
    @Test
    func normal() {
        let sut = TitleForState(normal: "test title")
        
        #expect(sut.title(for: .normal) == "test title")
        #expect(sut.title(for: .highlighted) == "test title")
        #expect(sut.title(for: .selected) == "test title")
        #expect(sut.title(for: .focused) == "test title")
        #expect(sut.title(for: [.selected, .highlighted]) == "test title")
        #expect(sut.title(for: [.focused, .highlighted]) == "test title")
        #expect(sut.title(for: .disabled) == "test title")
    }
    
    @Test
    func setAll() {
        let sut = TitleForState(
            normal: "test title1",
            highlighted: "test title2",
            selected: "test title3",
            focused: "test title4",
            selectedHighlighted: "test title5",
            focusedHighlighted: "test title6",
            disabled: "test title7"
        )
        
        #expect(sut.title(for: .normal) == "test title1")
        #expect(sut.title(for: .highlighted) == "test title2")
        #expect(sut.title(for: .selected) == "test title3")
        #expect(sut.title(for: .focused) == "test title4")
        #expect(sut.title(for: [.selected, .highlighted]) == "test title5")
        #expect(sut.title(for: [.focused, .highlighted]) == "test title6")
        #expect(sut.title(for: .disabled) == "test title7")
    }
    
}
