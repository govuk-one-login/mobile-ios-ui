@testable @_spi(unstable) import DesignSystem
import Testing
import UIKit

@MainActor
struct EnableStateTests {
    @Test func defaultsToEnabled() {
        let sut = EnableState()
        #expect(sut.isEnabled == true)
    }
    
    @Test func canBeInitialisedAsDisabled() {
        let sut = EnableState(false)
        #expect(sut.isEnabled == false)
    }
    
    @Test func onChangeCalledWhenValueChanges() {
        let sut = EnableState(true)
        var received: Bool?
        sut.onChange = { received = $0 }
        
        sut.isEnabled = false
        #expect(received == false)
    }
    
    @Test func onChangeCalledOnEverySet() {
        let sut = EnableState(true)
        var callCount = 0
        sut.onChange = { _ in callCount += 1 }
        
        sut.isEnabled = true
        #expect(callCount == 1)
    }
}

@MainActor
struct ControlViewModelTests {
    @Test func buttonStartsDisabledWhenEnableStateIsFalse() {
        let viewModel = GDSButtonViewModel(
            title: "Test",
            style: .primary,
            buttonAction: .action({ }),
            enableState: false
        )
        
        let view = viewModel.createUIView()
        let button = view as? GDSButton
        #expect(button?.isEnabled == false)
    }
    
    @Test func buttonStartsEnabledWhenEnableStateIsTrue() {
        let viewModel = GDSButtonViewModel(
            title: "Test",
            style: .primary,
            buttonAction: .action({ }),
            enableState: true
        )
        
        let view = viewModel.createUIView()
        let button = view as? GDSButton
        #expect(button?.isEnabled == true)
    }
    
    @Test func buttonStartsEnabledWhenNoEnableState() {
        let viewModel = GDSButtonViewModel(
            title: "Test",
            style: .primary,
            buttonAction: .action({ })
        )
        
        let view = viewModel.createUIView()
        let button = view as? GDSButton
        #expect(button?.isEnabled == true)
    }
    
    @Test func buttonEnablesWhenEnableStateChanges() {
        let viewModel = GDSButtonViewModel(
            title: "Test",
            style: .primary,
            buttonAction: .action({ }),
            enableState: false
        )
        
        let view = viewModel.createUIView()
        let button = view as? GDSButton
        #expect(button?.isEnabled == false)
        
        viewModel.enable()
        #expect(button?.isEnabled == true)
    }
    
    @Test func buttonDisablesWhenEnableStateChanges() {
        let viewModel = GDSButtonViewModel(
            title: "Test",
            style: .primary,
            buttonAction: .action({ }),
            enableState: true
        )
        
        let view = viewModel.createUIView()
        let button = view as? GDSButton
        #expect(button?.isEnabled == true)
        
        viewModel.disable()
        #expect(button?.isEnabled == false)
    }
}
