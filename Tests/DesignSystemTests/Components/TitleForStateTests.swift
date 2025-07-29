@testable import DesignSystem
import Testing
import UIKit

struct TitleForStateTests {
    
    @Test
    func normal() {
        let sut = TitleForState(normal: "test title")
        
        #expect(sut.forState(.normal) == "test title")
        #expect(sut.forState(.highlighted) == "test title")
        #expect(sut.forState(.selected) == "test title")
        #expect(sut.forState(.focused) == "test title")
        #expect(sut.forState([.selected, .highlighted]) == "test title")
        #expect(sut.forState([.focused, .highlighted]) == "test title")
        #expect(sut.forState(.disabled) == "test title")
        
        #expect(!sut.isSelectable)
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
        
        #expect(sut.forState(.normal) == "test title1")
        #expect(sut.forState(.highlighted) == "test title2")
        #expect(sut.forState(.selected) == "test title3")
        #expect(sut.forState(.focused) == "test title4")
        #expect(sut.forState([.selected, .highlighted]) == "test title5")
        #expect(sut.forState([.focused, .highlighted]) == "test title6")
        #expect(sut.forState(.disabled) == "test title7")
        
        #expect(sut.isSelectable)
    }
    
    @Test
    func expressibleByStringLiteral() async throws {
        let sut: TitleForState = "title"
        #expect(sut.forState(.normal) == "title")
    }
    
}
