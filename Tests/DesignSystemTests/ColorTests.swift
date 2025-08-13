@testable import DesignSystem
import Testing
import UIKit

struct ColorTests {
    
    @Test func test_Color_Black1() async throws {
        let expectedColor = UIColor.fromHex("#0B0C0C")
        
        let sut = DesignSystem.Color.Base.black1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Charcoal() async throws {
        let expectedColor = UIColor.fromHex("#262626")
        
        let sut = DesignSystem.Color.Base.charcoal
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green1() async throws {
        let expectedColor = UIColor.fromHex("#00703C")
        
        let sut = DesignSystem.Color.Base.green1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green2() async throws {
        let expectedColor = UIColor.fromHex("#008547")
        
        let sut = DesignSystem.Color.Base.green2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green3() async throws {
        let expectedColor = UIColor.fromHex("#03CD6E")
        
        let sut = DesignSystem.Color.Base.green3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green4() async throws {
        let expectedColor = UIColor.fromHex("#CCE2D8")
        
        let sut = DesignSystem.Color.Base.green4
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green5() async throws {
        let expectedColor = UIColor.fromHex("#002D18")
        
        let sut = DesignSystem.Color.Base.green5
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green6() async throws {
        let expectedColor = UIColor.fromHex("#029A53")
        
        let sut = DesignSystem.Color.Base.green6
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green7() async throws {
        let expectedColor = UIColor.fromHex("#007840")
        
        let sut = DesignSystem.Color.Base.green7
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green8() async throws {
        let expectedColor = UIColor.fromHex("#00542D")
        
        let sut = DesignSystem.Color.Base.green8
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_White() async throws {
        let expectedColor = UIColor.fromHex("#FFFFFF")
        
        let sut = DesignSystem.Color.Base.white
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Blue1() async throws {
        let expectedColor = UIColor.fromHex("#0F385C")
        
        let sut = DesignSystem.Color.Base.blue1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
        
    @Test func test_Color_Blue2() async throws {
        let expectedColor = UIColor.fromHex("#1D70B8")
        
        let sut = DesignSystem.Color.Base.blue2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Blue3() async throws {
        let expectedColor = UIColor.fromHex("#EFFFFF")
        
        let sut = DesignSystem.Color.Base.blue3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Teal() async throws {
        let expectedColor = UIColor.fromHex("#0D697C")
        
        let sut = DesignSystem.Color.Base.teal
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Grey1() async throws {
        let expectedColor = UIColor.fromHex("#505A54")
        
        let sut = DesignSystem.Color.Base.grey1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
   
    @Test func test_Color_Grey2() async throws {
        let expectedColor = UIColor.fromHex("#6F777B")
        
        let sut = DesignSystem.Color.Base.grey2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
        
    @Test func test_Color_Grey3() async throws {
        let expectedColor = UIColor.fromHex("#B1B4B6")
        
        let sut = DesignSystem.Color.Base.grey3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Grey4() async throws {
        let expectedColor = UIColor.fromHex("#F3F2F1")
        
        let sut = DesignSystem.Color.Base.grey4
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Grey5() async throws {
        let expectedColor = UIColor.fromHex("#F2F2F7")
        
        let sut = DesignSystem.Color.Base.grey5
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Grey6() async throws {
        let expectedColor = UIColor.fromHex("#939393")
        
        let sut = DesignSystem.Color.Base.grey6
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Red1() async throws {
        let expectedColor = UIColor.fromHex("#D4351C")
        
        let sut = DesignSystem.Color.Base.red1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Red2() async throws {
        let expectedColor = UIColor.fromHex("#FF6961")
        
        let sut = DesignSystem.Color.Base.red2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Red3() async throws {
        let expectedColor = UIColor.fromHex("#55150B")
        
        let sut = DesignSystem.Color.Base.red3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Red4() async throws {
        let expectedColor = UIColor.fromHex("#9F2815")
        
        let sut = DesignSystem.Color.Base.red4
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Pink1() async throws {
        let expectedColor = UIColor.fromHex("#F7DEE5")
        
        let sut = DesignSystem.Color.Base.pink1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Pink2() async throws {
        let expectedColor = UIColor.fromHex("#FFF4FD")
        
        let sut = DesignSystem.Color.Base.pink2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Yellow1() async throws {
        let expectedColor = UIColor.fromHex("#FFDD00")
        
        let sut = DesignSystem.Color.Base.yellow1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Yellow2() async throws {
        let expectedColor = UIColor.fromHex("#665800")
        
        let sut = DesignSystem.Color.Base.yellow2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Yellow3() async throws {
        let expectedColor = UIColor.fromHex("#FBF5B5")
        
        let sut = DesignSystem.Color.Base.yellow3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Yellow4() async throws {
        let expectedColor = UIColor.fromHex("#BFA600")
        
        let sut = DesignSystem.Color.Base.yellow4
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Gold1() async throws {
        let expectedColor = UIColor.fromHex("#B89746")
        
        let sut = DesignSystem.Color.Base.gold1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Gold2() async throws {
        let expectedColor = UIColor.fromHex("#DDC78E")
        
        let sut = DesignSystem.Color.Base.gold2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_DarkPurple() async throws {
        let expectedColor = UIColor.fromHex("#532A45")
        
        let sut = DesignSystem.Color.Base.darkPurple
        #expect(sut.cgColor == expectedColor.cgColor)
    }
}
