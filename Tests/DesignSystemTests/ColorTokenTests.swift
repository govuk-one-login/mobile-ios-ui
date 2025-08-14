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
    
    @Test func test_ColorToken_Text_Overlay() async throws {
        let expectedColor = DesignSystem.Color.Base.white
        
        let sut = DesignSystem.Color.Text.statusOverlay
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    // MARK: - Background Tokens

    @Test func test_ColorToken_Background_homeHeader() async throws {
        let expectedLightColor = DesignSystem.Color.Base.blue2
        let expectedDarkColor = DesignSystem.Color.Base.blue1
        let sut = DesignSystem.Color.Backgrounds.homeHeader
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Background_Card() async throws {
        let expectedLightColor = DesignSystem.Color.Base.white
        let expectedDarkColor = DesignSystem.Color.Base.charcoal
        let sut = DesignSystem.Color.Backgrounds.card
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Background_Overlay() async throws {
        let expectedColor = DesignSystem.Color.Base.grey1
        
        let sut = DesignSystem.Color.Backgrounds.statusOverlay
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    // MARK: - Divider Tokens
    
    @Test func test_ColorToken_Divider_Default() async throws {
        let expectedLightColor = DesignSystem.Color.Base.grey2
        let expectedDarkColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Dividers.default
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Divider_Card() async throws {
        let expectedLightColor = DesignSystem.Color.Base.grey1
        let expectedDarkColor = DesignSystem.Color.Base.grey3
        let sut = DesignSystem.Color.Dividers.card
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    // MARK: - Button Tokens
    
    @Test func test_ColorToken_Buttons_primaryForeground() async throws {
        let expectedColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Buttons.primaryForeground
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryForegroundFocused() async throws {
        let expectedColor = DesignSystem.Color.Base.black1
        let sut = DesignSystem.Color.Buttons.primaryForegroundFocused
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryForegroundDisabled() async throws {
        let expectedColor = DesignSystem.Color.Base.charcoal
        let sut = DesignSystem.Color.Buttons.primaryForegroundDisabled
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryBackground() async throws {
        let expectedColor = DesignSystem.Color.Base.green1
        let sut = DesignSystem.Color.Buttons.primaryBackground
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryBackgroundHighlighted() async throws {
        let expectedColor = DesignSystem.Color.Base.green8
        let sut = DesignSystem.Color.Buttons.primaryBackgroundHighlighted
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryBackgroundFocused() async throws {
        let expectedColor = DesignSystem.Color.Base.yellow1
        let sut = DesignSystem.Color.Buttons.primaryBackgroundFocused
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryBackgroundDisabled() async throws {
        let expectedColor = DesignSystem.Color.Base.grey3
        let sut = DesignSystem.Color.Buttons.primaryBackgroundDisabled
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_primaryBackgroundFocusedHighlighted() async throws {
        let expectedColor = DesignSystem.Color.Base.yellow4
        let sut = DesignSystem.Color.Buttons.primaryBackgroundFocusedHighlighted
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    
    @Test func test_ColorToken_Buttons_secondaryForeground() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.Buttons.secondaryForeground
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_secondaryForegroundFocused() async throws {
        let expectedLightColor = DesignSystem.Color.Base.black1
        let expectedDarkColor = DesignSystem.Color.Base.black1
        let sut = DesignSystem.Color.Buttons.secondaryForegroundFocused
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_secondaryForegroundHighlighted() async throws {
        let expectedColor = DesignSystem.Color.Base.green8
        let sut = DesignSystem.Color.Buttons.secondaryForegroundHighlighted
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_secondaryBackgroundFocused() async throws {
        let expectedColor = DesignSystem.Color.Base.yellow1
        let sut = DesignSystem.Color.Buttons.secondaryBackgroundFocused
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveForeground() async throws {
        let expectedColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Buttons.destructiveForeground
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveForegroundDisabled() async throws {
        let expectedColor = DesignSystem.Color.Base.charcoal
        let sut = DesignSystem.Color.Buttons.destructiveForegroundDisabled
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveBackground() async throws {
        let expectedColor = DesignSystem.Color.Base.red1
        let sut = DesignSystem.Color.Buttons.destructiveBackground
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveBackgroundFocused() async throws {
        let expectedColor = DesignSystem.Color.Base.yellow1
        let sut = DesignSystem.Color.Buttons.destructiveBackgroundFocused
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveBackgroundHighlighted() async throws {
        let expectedColor = DesignSystem.Color.Base.red4
        let sut = DesignSystem.Color.Buttons.destructiveBackgroundHighlighted
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_destructiveBackgroundDisabled() async throws {
        let expectedColor = DesignSystem.Color.Base.grey3
        let sut = DesignSystem.Color.Buttons.destructiveBackgroundDisabled
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_nativeButtonText() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.Buttons.nativeButtonText
        
        #expect(sut.lightColor.cgColor == expectedLightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_nativeButtonTextDestructive() async throws {
        let expectedLightColor = DesignSystem.Color.Base.red1
        let expectedDarkColor = DesignSystem.Color.Base.red2
        let sut = DesignSystem.Color.Buttons.nativeButtonTextDestructive
        
        #expect(sut.lightColor.cgColor == expectedLightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.cgColor)
    }
    
    // MARK: - Link Tokens
    
    @Test func test_ColorToken_Links_Default() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.Links.default
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    // MARK: - Icon tokens
    
    @Test func test_ColorToken_Icons_Default() async throws {
        let expectedLightColor = DesignSystem.Color.Base.black1
        let expectedDarkColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Icons.default
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Icons_Success() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green2
        let sut = DesignSystem.Color.Icons.success
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Icons_Error() async throws {
        let expectedLightColor = DesignSystem.Color.Base.black1
        let expectedDarkColor = DesignSystem.Color.Base.white
        let sut = DesignSystem.Color.Icons.error
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Icons_Destructive() async throws {
        let expectedColor = DesignSystem.Color.Base.red1
        let sut = DesignSystem.Color.Icons.destructive
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_ColorToken_Icons_Overlay() async throws {
        let expectedColor = DesignSystem.Color.Base.white
        
        let sut = DesignSystem.Color.Icons.statusOverlay
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
    
    // MARK: - Navigation tokens
    
    @Test func test_ColorToken_Navigation_Default() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.NavigationElements.navigationBarElements
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Navigation_Selected() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.NavigationElements.selectedTabIconAndLabel
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    // MARK: - Radio tokens
    
    @Test func test_ColorToken_Radio_Check() async throws {
        let expectedLightColor = DesignSystem.Color.Base.green1
        let expectedDarkColor = DesignSystem.Color.Base.green3
        let sut = DesignSystem.Color.SelectedIcon.check
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    // MARK: - Shadow tokens
    
    @Test func test_ColorToken_Shadow_Card() async throws {
        let expectedColor = DesignSystem.Color.Base.blackA15
        let sut = DesignSystem.Color.Shadows.card
        
        #expect(sut.lightColor.cgColor == expectedColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.cgColor)
    }
}
