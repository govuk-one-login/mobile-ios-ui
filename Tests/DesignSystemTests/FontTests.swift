@testable import DesignSystem
import Testing
import UIKit

struct FontTests {
    
    // MARK: - Raw Fonts
    
    @Test func test_Font_largeTitle() async throws {
        let expectedFont = UIFont(.largeTitle)
        
        let sut = DesignSystem.Font.Base.largeTitle
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_largeTitleBold() async throws {
        let expectedFont = UIFont(.largeTitle, weight: .bold)
        
        let sut = DesignSystem.Font.Base.largeTitleBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title1() async throws {
        let expectedFont = UIFont(.title1)
        
        let sut = DesignSystem.Font.Base.title1
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title2() async throws {
        let expectedFont = UIFont(.title2)
        
        let sut = DesignSystem.Font.Base.title2
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title3() async throws {
        let expectedFont = UIFont(.title3)
        
        let sut = DesignSystem.Font.Base.title3
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title3SemiBold() async throws {
        let expectedFont = UIFont(.title3, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.title3SemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title3Bold() async throws {
        let expectedFont = UIFont(.title3, weight: .bold)
        
        let sut = DesignSystem.Font.Base.title3Bold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_headline() async throws {
        let expectedFont = UIFont(.headline)
        
        let sut = DesignSystem.Font.Base.headline
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_headlineSemiBold() async throws {
        let expectedFont = UIFont(.headline, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.headlineSemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_subheadline() async throws {
        let expectedFont = UIFont(.subheadline)
        
        let sut = DesignSystem.Font.Base.subheadline
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_subheadlineSemiBold() async throws {
        let expectedFont = UIFont(.subheadline, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.subheadlineSemiBold
        #expect(sut == expectedFont)
    }
        
    @Test func test_Font_body() async throws {
        let expectedFont = UIFont(.body)
        
        let sut = DesignSystem.Font.Base.body
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_bodySemiBold() async throws {
        let expectedFont = UIFont(.body, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.bodySemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_bodyBold() async throws {
        let expectedFont = UIFont(.body, weight: .bold)
        
        let sut = DesignSystem.Font.Base.bodyBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_bodyBoldMonospaced() async throws {
        let expectedFont = UIFont(.body, weight: .bold, design: .monospaced)
        
        let sut = DesignSystem.Font.Base.bodyBoldMonospaced
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_callout() async throws {
        let expectedFont = UIFont(.callout)
        
        let sut = DesignSystem.Font.Base.callout
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_calloutSemiBold() async throws {
        let expectedFont = UIFont(.callout, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.calloutSemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_footnote() async throws {
        let expectedFont = UIFont(.footnote)
        
        let sut = DesignSystem.Font.Base.footnote
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_footnoteSemiBold() async throws {
        let expectedFont = UIFont(.footnote, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.footnoteSemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption1() async throws {
        let expectedFont = UIFont(.caption1)
        
        let sut = DesignSystem.Font.Base.caption1
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption1Medium() async throws {
        let expectedFont = UIFont(.caption1, weight: .medium)
        
        let sut = DesignSystem.Font.Base.caption1Medium
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption2() async throws {
        let expectedFont = UIFont(.caption2)
        
        let sut = DesignSystem.Font.Base.caption2
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption2SemiBold() async throws {
        let expectedFont = UIFont(.caption2, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.caption2SemiBold
        #expect(sut == expectedFont)
    }

    // MARK: - Font Helpers
    @Test func test_Font_preferredMonospacedFont() async throws {
        let expectedFont = UIFont(.title3, weight: .bold, design: .monospaced)
        
        let sut = DesignSystem.Font.Base.title3BoldMonospaced
        #expect(sut == expectedFont)
    }
}
