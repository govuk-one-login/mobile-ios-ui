import DesignSystem
import Testing

struct IconStyleTests {

    @Test func arrowUpRight() async throws {
        let expectation = IconStyle(icon: "arrow.up.right", position: .trailing, accessibilityHint: "opens in your web browser")
        #expect(IconStyle.arrowUpRight == expectation)
    }
    
    @Test func qrCode() async throws {
        let expectation = IconStyle(icon: "qrcode", position: .leading)
        #expect(IconStyle.qrCode == expectation)
    }

}
