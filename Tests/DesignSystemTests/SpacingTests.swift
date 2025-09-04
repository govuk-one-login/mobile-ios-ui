@testable import DesignSystem
import Testing
import UIKit
import XCTest

struct SpacingTests {
    
    @Test func test_Spacing_xSmall() async throws {
        let expectedValue: Double = 4
        
        let sut = DesignSystem.Spacing.xSmall
        #expect(sut == expectedValue)
    }
    
    @Test func test_Spacing_Small() async throws {
        let expectedValue: Double = 8
        
        let sut = DesignSystem.Spacing.small
        #expect(sut == expectedValue)
    }
    
    @Test func test_Spacing_Medium() async throws {
        let expectedValue: Double = 16
        
        let sut = DesignSystem.Spacing.medium
        #expect(sut == expectedValue)
    }
    
    @Test func test_Spacing_Default() async throws {
        let expectedValue: Double = 16
        
        let sut = DesignSystem.Spacing.default
        #expect(sut == expectedValue)
    }
    
    @Test func test_Spacing_Large() async throws {
        let expectedValue: Double = 24
        
        let sut = DesignSystem.Spacing.large
        #expect(sut == expectedValue)
    }
    
    @Test func test_Spacing_xLarge() async throws {
        let expectedValue: Double = 32
        
        let sut = DesignSystem.Spacing.xLarge
        #expect(sut == expectedValue)
    }
}
