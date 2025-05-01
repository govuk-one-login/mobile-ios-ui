@testable import DesignSystem
import Testing
import UIKit

struct ColorTests {
    
    @Test func test_Color_Black1() async throws {
        let expectedColor = UIColor.fromHex("#0B0C0C")
        
        let sut = DesignSystem.Color.black1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green1() async throws {
        let expectedColor = UIColor.fromHex("#00703C")
        
        let sut = DesignSystem.Color.green1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Green2() async throws {
        let expectedColor = UIColor.fromHex("#008547")
        
        let sut = DesignSystem.Color.green2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_White() async throws {
        let expectedColor = UIColor.fromHex("#FFFFFF")
        
        let sut = DesignSystem.Color.white
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Blue1() async throws {
        let expectedColor = UIColor.fromHex("#0F385C")
        
        let sut = DesignSystem.Color.blue1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
        
    @Test func test_Color_Blue2() async throws {
        let expectedColor = UIColor.fromHex("#1D70B8")
        
        let sut = DesignSystem.Color.blue2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Teal() async throws {
        let expectedColor = UIColor.fromHex("#008670")
        
        let sut = DesignSystem.Color.teal
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Grey1() async throws {
        let expectedColor = UIColor.fromHex("#505A54")
        
        let sut = DesignSystem.Color.grey1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
   
    @Test func test_Color_Grey2() async throws {
        let expectedColor = UIColor.fromHex("#6F777B")
        
        let sut = DesignSystem.Color.grey2
        #expect(sut.cgColor == expectedColor.cgColor)
    }
        
    @Test func test_Color_Grey3() async throws {
        let expectedColor = UIColor.fromHex("#B1B4B6")
        
        let sut = DesignSystem.Color.grey3
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Red1() async throws {
        let expectedColor = UIColor.fromHex("#D4351C")
        
        let sut = DesignSystem.Color.red1
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Yellow() async throws {
        let expectedColor = UIColor.fromHex("#FFDD00")
        
        let sut = DesignSystem.Color.yellow
        #expect(sut.cgColor == expectedColor.cgColor)
    }
    
    @Test func test_Color_Purple() async throws {
        let expectedColor = UIColor.fromHex("#774495")
        
        let sut = DesignSystem.Color.purple
        #expect(sut.cgColor == expectedColor.cgColor)
    }
}
