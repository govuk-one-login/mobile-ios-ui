import UIKit

@MainActor
public protocol ControlViewModel {
    var enableState: EnableState? { get }
}

extension ControlViewModel {
    public var enableState: EnableState? { nil }
    
    public func isEnabledToggle() {
        enableState?.isEnabled.toggle()
    }
    
    public func enable() {
        enableState?.isEnabled = true
    }
    
    public func disable() {
        enableState?.isEnabled = false
    }
}
