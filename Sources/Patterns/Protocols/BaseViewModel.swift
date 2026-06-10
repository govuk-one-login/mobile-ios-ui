import Foundation

@MainActor
public protocol BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString? { get }
    var backButtonTitle: GDSLocalisedString? { get }
    var backButtonIsHidden: Bool { get }
    
    var didAppear: DesignSystem.Action? { get }
    var didDismiss: DesignSystem.Action? { get }
}
