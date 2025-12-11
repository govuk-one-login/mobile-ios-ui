import DesignSystem
import Testing
import UIKit

struct LocalisationTests {
    @Test
    func rowLocalisation() async throws {
        let expectation = "Agor mewn porwr gwe"

        #expect("externalLinkAccessibilityHint".getWelshString() == expectation)
    }
}
