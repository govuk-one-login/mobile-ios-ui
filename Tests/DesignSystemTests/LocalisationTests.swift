import DesignSystem
import Testing
import UIKit

struct LocalisationTests {
    @Test
    func rowLocalisation() async throws {
        let expectation = "Agor mewn porwr gwe"

        #expect("externalLinkAccessibilityHint".getWelshString() == expectation)
    }
    
    @Test
    func bulletedListLocalisation() async throws {
        let bulletedList = "rhestr bwledi %@ eitem"
        let bullet = "bwledt"

        #expect("bulletedList".getWelshString() == bulletedList)
        #expect("bullet".getWelshString() == bullet)
    }
    
    @Test
    func numberedListLocalisation() async throws {
        let expectation = "rhestr wedi'i rhifo %@ o eitemau"

        #expect("numberedList".getWelshString() == expectation)
    }
}
