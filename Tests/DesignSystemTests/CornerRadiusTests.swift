@testable import DesignSystem
import Testing
import UIKit

struct CornerRadiusTests {
    
    @Test func test_CornerRadius_ExtraSmall() async throws {
        let expectedValue: CGFloat = 4
        
        let sut = DesignSystem.CornerRadius.extraSmall
        #expect(sut == expectedValue)
    }
    
    @Test func test_CornerRadius_Small() async throws {
        let expectedValue: CGFloat = 8
        
        let sut = DesignSystem.CornerRadius.small
        #expect(sut == expectedValue)
    }
    
    @Test func test_CornerRadius_Default() async throws {
        let expectedValue: CGFloat = 16
        
        let sut = DesignSystem.CornerRadius.default
        #expect(sut == expectedValue)
    }
    
}
