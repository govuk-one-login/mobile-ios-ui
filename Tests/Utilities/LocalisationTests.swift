import DesignSystem
import Testing
import UIKit

struct LocalisationTests {
    @Test
    func rowLocalisation() async throws {
        let key = "externalLinkAccessibilityHint"
        let welsh = "Agor mewn porwr gwe"
        let english = "opens in web browser"

        #expect(key.getWelshString() == welsh)
        #expect(GDSLocalisedString(stringKey: key, bundle: .designSystem).value == english)
    }
    
    @Test
    func bulletedListLocalisation() async throws {
        let listKey = "bulletedList"
        let bulletKey = "bullet"
        
        let listEnglish = "bulleted list 1 items"
        let listWelsh = "rhestr bwledi %@ eitem"
        
        let bulletEnglish = "bullet"
        let bulletWelsh = "bwledt"

        #expect(
            GDSLocalisedString(
                stringKey: listKey,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == listEnglish
        )
        #expect(listKey.getWelshString() == listWelsh)
        
        #expect(
            GDSLocalisedString(
                stringKey: bulletKey,
                bundle: .designSystem
            ).value == bulletEnglish
        )
        #expect(bulletKey.getWelshString() == bulletWelsh)
    }
    
    @Test
    func numberedListLocalisation() async throws {
        let key = "numberedList"
        let english = "numbered list 1 items"
        let welsh = "rhestr wedi'i rhifo %@ o eitemau"
        
        #expect(
            GDSLocalisedString(
                stringKey: key,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == english
        )
        
        #expect(key.getWelshString() == welsh)
    }
    
    @Test
    func errorIconLocalisation() async throws {
        let key = "voiceOverErrorPrefix"
        let english = "Error"
        let welsh = "Gwall"
        
        #expect(
            GDSLocalisedString(
                stringKey: key,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == english
        )
        
        #expect(key.getWelshString() == welsh)
    }
    
    @Test
    func warningIconLocalisation() async throws {
        let key = "voiceOverWarningPrefix"
        let english = "Warning"
        let welsh = "Rhybudd"
        
        #expect(
            GDSLocalisedString(
                stringKey: key,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == english
        )
        
        #expect(key.getWelshString() == welsh)
    }
    
    @Test
    func progressIndicatorLocalisation() async throws {
        let defaultKey = "defaultLoadingText"
        let englishDefaultKey = "Loading"
        let welshDefaultKey = "Llwytho"
        
        #expect(
            GDSLocalisedString(
                stringKey: defaultKey,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == englishDefaultKey
        )
        
        #expect(defaultKey.getWelshString() == welshDefaultKey)
        
        let fiveSecondKey = "fiveSecondLoadingText"
        let englishfiveSecondKey = "Still loading"
        let welshfiveSecondKey = "Dal i lwytho"
        
        #expect(
            GDSLocalisedString(
                stringKey: fiveSecondKey,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == englishfiveSecondKey
        )
        
        #expect(fiveSecondKey.getWelshString() == welshfiveSecondKey)
        
        let tenSecondKey = "tenSecondLoadingText"
        let englishTenSecondKey = "Still loading, keep waiting"
        let welshTenSecondKey = "Dal i lwytho, daliwch ati i aros"
        
        #expect(
            GDSLocalisedString(
                stringKey: tenSecondKey,
                variableKeys: ["1"],
                bundle: .designSystem
            ).value == englishTenSecondKey
        )
        
        #expect(tenSecondKey.getWelshString() == welshTenSecondKey)
    }
}
