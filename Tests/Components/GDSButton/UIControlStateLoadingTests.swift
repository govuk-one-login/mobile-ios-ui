@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
struct UIControlStateLoadingTests {

    @Test("Loading state uses the expected application-reserved raw value")
    func loadingRawValue() {
        #expect(UIControl.State.loading.rawValue == 1 << 16)
    }

    @Test("Loading bit sits within UIKit's application-reserved range")
    func loadingWithinApplicationRange() {
        // UIKit reserves 0x00FF0000 for application-defined states.
        #expect(UIControl.State.loading.rawValue & UIControl.State.application.rawValue == UIControl.State.loading.rawValue)
    }

    @Test("Composing loading with disabled preserves both bits")
    func loadingComposesWithDisabled() {
        let composite: UIControl.State = [.disabled, .loading]
        #expect(composite.contains(.loading))
        #expect(composite.contains(.disabled))
    }

    @Test("A plain loading state does not contain disabled")
    func plainLoadingHasNoDisabled() {
        let state: UIControl.State = .loading
        #expect(state.contains(.loading))
        #expect(!state.contains(.disabled))
    }

    @Test("Loading does not collide with built-in control states")
    func loadingIsDistinctFromBuiltInStates() {
        #expect(!UIControl.State.loading.contains(.highlighted))
        #expect(!UIControl.State.loading.contains(.disabled))
        #expect(!UIControl.State.loading.contains(.selected))
        #expect(!UIControl.State.loading.contains(.focused))
    }
}
