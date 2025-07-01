@testable import DesignSystem
import Testing
import UIKit

struct ColorTokenTests {
    
    // MARK: - Text Tokens
    
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
    
    @Test func test_ColorToken_Text_StatusTag() async throws {
        let expectedColor = DesignSystem.Color.red1
        let sut = DesignSystem.Color.Text.statusTag
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Text_InvalidWalletDocumentAction() async throws {
        let expectedColor = DesignSystem.Color.red1
        let sut = DesignSystem.Color.Text.invalidWalletDocumentAction
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    // MARK: - Background Tokens
    
    @Test func test_ColorToken_Background_ExpiredWalletDocument() async throws {
        let expectedColor = DesignSystem.Color.grey4
        let sut = DesignSystem.Color.Backgrounds.expiredWalletDocument
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Background_VeteranInfoHeader() async throws {
        let expectedColor = DesignSystem.Color.darkPurple
        let sut = DesignSystem.Color.Backgrounds.veteranInformationHeader
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Background_DBSInfoHeader() async throws {
        let expectedColor = DesignSystem.Color.dbsPurple
        let sut = DesignSystem.Color.Backgrounds.dbsInformationHeader
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Background_NINOHeader() async throws {
        let expectedColor = DesignSystem.Color.hmrcGreen
        let sut = DesignSystem.Color.Backgrounds.ninoInformationHeader
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    
    // MARK: - Border Tokens
    
    @Test func test_ColorToken_Border_StatusTag() async throws {
        let expectedColor = DesignSystem.Color.red1
        let sut = DesignSystem.Color.Borders.statusTag
        
        #expect(sut.lightColor.cgColor == expectedColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedColor.darkColor.cgColor)
    }
    
    // MARK: - Divider Tokens
    
    @Test func test_ColorToken_Divider_Default() async throws {
        let expectedLightColor = DesignSystem.Color.grey2
        let expectedDarkColor = DesignSystem.Color.white
        let sut = DesignSystem.Color.Dividers.default
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    
    // MARK: - Button Tokens
    
    @Test func test_ColorToken_Buttons_secondaryTextAndIcon() async throws {
        let expectedLightColor = DesignSystem.Color.green1
        let expectedDarkColor = DesignSystem.Color.green3
        let sut = DesignSystem.Color.Buttons.secondaryTextAndIcon
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
    
    @Test func test_ColorToken_Buttons_focusStateTextAndIcon() async throws {
        let expectedLightColor = DesignSystem.Color.black1
        let expectedDarkColor = DesignSystem.Color.black1
        let sut = DesignSystem.Color.Buttons.focusStateTextAndIcon
        
        #expect(sut.lightColor.cgColor == expectedLightColor.lightColor.cgColor)
        #expect(sut.darkColor.cgColor == expectedDarkColor.darkColor.cgColor)
    }
}
