@testable import DesignSystem
import Testing

struct DateFormatTests {
    
    @Test func test_DateFormat_Default() async throws {
        let expectedValue: String = "d MMMM yyyy"
        
        let sut = DesignSystem.DateFormat.default
        #expect(sut == expectedValue)
    }
}
