import DesignSystem
import Testing

struct IconStyleTests {

    @Test func arrowUpRight() async throws {
        let expectation = IconStyle(icon: "arrow.up.right", position: .trailing, accessibilityHint: "opens in web browser")
        #expect(IconStyle.arrowUpRight == expectation)
    }
    
    @Test func qrCode() async throws {
        let expectation = IconStyle(icon: "qrcode", position: .leading)
        #expect(IconStyle.qrCode == expectation)
    }
    
    @Test func minimalInitSuccess() async throws {
        let sut = IconStyle(icon: "sun.min")
        #expect(sut?.icon == "sun.min")
        #expect(sut?.position == .trailing)
        #expect(sut?.accessibilityHint == nil)
    }
    
    @Test func minimalInitNil() async throws {
        let sut = IconStyle(icon: nil)
        #expect(sut == nil)
    }

}
