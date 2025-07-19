@testable import DesignSystem
import Testing
import UIKit

struct ColorTokenTests {
    
    // MARK: - Text Tokens
    
    @Test func test_ColorToken_Text_Primary() async throws {
        let expectedColor = UIColor(
            light: DesignSystem.Color.Base.black1,
            dark: DesignSystem.Color.Base.white
        )
        
        let sut = DesignSystem.Color.Text.primary
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Text_Secondary() async throws {
        let expectedColor = UIColor(
            light: DesignSystem.Color.Base.grey1,
            dark: DesignSystem.Color.Base.white
        )
        
        let sut = DesignSystem.Color.Text.secondary
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    // MARK: - Background Tokens

    
    // MARK: - Divider Tokens
    
    @Test func test_ColorToken_Divider_Default() async throws {
        let expectedLightColor = DesignSystem.Color.Base.grey2
        let expectedDarkColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Dividers.default
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    
    // MARK: - Button Tokens
    
    @Test func test_ColorToken_Buttons_secondaryTextAndIcon() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.Buttons.secondaryForeground
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_focusStateTextAndIcon() async throws {
        let expectedLightColor = DesignSystem.Color.Base.black1
        let expectedDarkColor = DesignSystem.Color.Base.black1
        let sut = DesignSystem.Color.Buttons.secondaryForegroundFocus
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
}
