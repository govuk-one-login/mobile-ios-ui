@testable import DesignSystem
import Testing
import UIKit

struct UIColorExtensionTests {
    @Test func test_Color_FromHexString() {
        #expect(UIColor.fromHex("#FF0000") == .red)
    }
    
    @Test func test_Color_FromHexString_Invalid() {
        #expect(UIColor.fromHex("#QQQQQQ") == .label)
    }
    
    @Test func test_Color_darkColor() {
        #expect(UIColor.fromHex("#FF0000").darkColor == .red)
    }
    
    @Test func test_Color_lightColor() {
        #expect(UIColor.fromHex("#FF0000").lightColor == .red)
    }

    
}
