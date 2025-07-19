@testable import DesignSystem
import Testing
import UIKit

struct FontTests {
    
    // MARK: - Raw Fonts
    
    @Test func test_Font_largeTitle() async throws {
        let expectedFont = UIFont.preferredFont(for: .largeTitle)
        
        let sut = DesignSystem.Font.Base.largeTitle
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_largeTitleBold() async throws {
        let expectedFont = UIFont.preferredFont(for: .largeTitle, weight: .bold)
        
        let sut = DesignSystem.Font.Base.largeTitleBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title1() async throws {
        let expectedFont = UIFont.preferredFont(for: .title1)
        
        let sut = DesignSystem.Font.Base.title1
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title2() async throws {
        let expectedFont = UIFont.preferredFont(for: .title2)
        
        let sut = DesignSystem.Font.Base.title2
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title3() async throws {
        let expectedFont = UIFont.preferredFont(for: .title3)
        
        let sut = DesignSystem.Font.Base.title3
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_title3Bold() async throws {
        let expectedFont = UIFont.preferredFont(for: .title3, weight: .bold)
        
        let sut = DesignSystem.Font.Base.title3Bold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_headline() async throws {
        let expectedFont = UIFont.preferredFont(for: .headline)
        
        let sut = DesignSystem.Font.Base.headline
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_subheadline() async throws {
        let expectedFont = UIFont.preferredFont(for: .subheadline)
        
        let sut = DesignSystem.Font.Base.subheadline
        #expect(sut == expectedFont)
    }
        
    @Test func test_Font_body() async throws {
        let expectedFont = UIFont.preferredFont(for: .body)
        
        let sut = DesignSystem.Font.Base.body
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_bodySemiBold() async throws {
        let expectedFont = UIFont.preferredFont(for: .body, weight: .semibold)
        
        let sut = DesignSystem.Font.Base.bodySemiBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_bodyBold() async throws {
        let expectedFont = UIFont.preferredFont(for: .body, weight: .bold)
        
        let sut = DesignSystem.Font.Base.bodyBold
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_callout() async throws {
        let expectedFont = UIFont.preferredFont(for: .callout)
        
        let sut = DesignSystem.Font.Base.callout
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_footnote() async throws {
        let expectedFont = UIFont.preferredFont(for: .footnote)
        
        let sut = DesignSystem.Font.Base.footnote
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption1() async throws {
        let expectedFont = UIFont.preferredFont(for: .caption1)
        
        let sut = DesignSystem.Font.Base.caption1
        #expect(sut == expectedFont)
    }
    
    @Test func test_Font_caption2() async throws {
        let expectedFont = UIFont.preferredFont(for: .caption2)
        
        let sut = DesignSystem.Font.Base.caption2
        #expect(sut == expectedFont)
    }

    // MARK: - Font Helpers
    @Test func test_Font_preferredMonospacedFont() async throws {
        let expectedFont = UIFont.preferredMonospacedFont(for: .title2, weight: .bold, size: 20)
        
        let sut = DesignSystem.Font.Base.title2Monospaced
        #expect(sut == expectedFont)
    }
}
