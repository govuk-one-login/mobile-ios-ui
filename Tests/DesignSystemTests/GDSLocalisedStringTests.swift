@testable import DesignSystem
import Foundation
import Testing

struct GDSLocalisedStringTests {
    @Test
    func test_stringLiteralInitialiser() throws {
        let sut = GDSLocalisedString(stringLiteral: "stringLiteralInitialiser")
        
        #expect(sut.value == "stringLiteralInitialiser")
    }
    
    @Test
    func test_firstNonStringLiteralInitialiser() throws {
        let sut = GDSLocalisedString(stringKey: "firstNonStringLiteral", "one", "two", "three")
        
        #expect(sut.value == "firstNonStringLiteral")
    }
    
    @Test
    func test_secondNonStringLiteralInitialiser() throws {
        let sut = GDSLocalisedString(stringKey: "secondNonStringLiteral", variableKeys: ["one", "two", "three"])
        
        #expect(sut.value == "secondNonStringLiteral")
    }
    
    @Test
    func test_descriptionProperty() throws {
        let sut = GDSLocalisedString(stringLiteral: "stringLiteralInitialiser")
        
        #expect(sut.description == "stringLiteralInitialiser")
    }
    
    @Test
    func test_attributedString_stringLiteralInitialiser() {
        let sut = GDSLocalisedString(stringLiteral: "stringLiteralInitialiser",
                                     stringAttributes: [("Literal", [.font: DesignSystem.Font.Base.bodyBold])])
        #expect(sut.attributedValue != nil)
    }
    
    @Test
    func test_attributedString_firstNonStringLiteralInitialiser() throws {
        let sut = GDSLocalisedString(stringKey: "firstNonStringLiteral", "one", "two", "three",
                                     stringAttributes: [("Literal", [.font: DesignSystem.Font.Base.bodyBold])])
        
        #expect(sut.value == "firstNonStringLiteral")
        #expect(sut.attributedValue != nil)
    }
    
    @Test
    func test_attributedString_secondNonStringLiteralInitialiser() throws {
        let sut = GDSLocalisedString(stringKey: "secondNonStringLiteral",
                                     variableKeys: ["one", "two", "three"],
                                     stringAttributes: [("Literal", [.font: DesignSystem.Font.Base.bodyBold])])
        
        #expect(sut.value == "secondNonStringLiteral")
        #expect(sut.attributedValue != nil)
    }
    
    @Test
    func test_attributedString_isNil() {
        let sut = GDSLocalisedString(stringLiteral: "stringLiteralInitialiser")
        #expect(sut.attributedValue == nil)
    }
    
    @Test
    func test_attributedString_withEmptyArray() {
        let sut = GDSLocalisedString(stringLiteral: "stringLiteralInitialiser",
                                     stringAttributes: [])
        #expect(sut.attributedValue == nil)
    }
}

extension GDSLocalisedStringTests {
    @Test
    func test_equatable() {
        let stringOne = GDSLocalisedString(stringKey: "firstNonStringLiteral", "one", "two", "three")
        #expect(stringOne == stringOne)
        
        let stringTwo = GDSLocalisedString(stringKey: "secondNonStringLiteral", "one", "two", "three")
        let stringThree = GDSLocalisedString(stringKey: "firstNonStringLiteral", "one", "two", "three", "four")
        #expect(stringOne != stringTwo)
        #expect(stringOne != stringThree)
    }
    
    @Test
    func test_equatableAttributes() {
        let stringOne = GDSLocalisedString(stringKey: "firstNonStringLiteral",
                                           stringAttributes: [("one", [NSAttributedString.Key.foregroundColor: DesignSystem.Color.Base.red1])])
        #expect(stringOne == stringOne)
        
        let stringTwo = GDSLocalisedString(stringKey: "firstNonStringLiteral")
        #expect(stringOne != stringTwo)
    }
}
