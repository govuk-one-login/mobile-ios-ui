@testable import DesignSystem
import Testing
import UIKit

struct ColorTokenTests {
        
    @Test func test_ColorToken_Text_Primary() async throws {
        let expectedColor = UIColor(
            light: DesignSystem.Color.black1,
            dark: DesignSystem.Color.white
        )
        
        let sut = DesignSystem.Color.Text.primary
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Text_Secondary() async throws {
        let expectedColor = UIColor(
            light: DesignSystem.Color.grey1,
            dark: DesignSystem.Color.white
        )
        
        let sut = DesignSystem.Color.Text.secondary
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
}
