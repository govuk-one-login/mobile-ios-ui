@testable import DesignSystem
import Testing

struct GDSScreenStyleTests {
    @Test
    func centred() {
        let sut = GDSScreenStyle.centred
        #expect(sut.verticalAlignment == .center)
        #expect(sut.horizontalAlignment == .fill)
        #expect(sut.defaultVerticalPadding.topPadding == 8)
        #expect(sut.defaultVerticalPadding.bottomPadding == 8)
        #expect(sut.defaultHorizontalPadding.leadingPadding == 16)
        #expect(sut.defaultHorizontalPadding.trailingPadding == 16)
    }
    
    @Test
    func top() {
        let sut = GDSScreenStyle.top
        #expect(sut.verticalAlignment == .top)
        #expect(sut.horizontalAlignment == .fill)
    }
    
    @Test
    func centreLeadingAligned() {
        let sut = GDSScreenStyle.centreLeading
        #expect(sut.verticalAlignment == .center)
        #expect(sut.horizontalAlignment == .leading)
    }
}
