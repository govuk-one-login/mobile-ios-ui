import Foundation

@MainActor
public protocol BaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString? { get }
    var backButtonTitle: GDSLocalisedString? { get }
    var backButtonIsHidden: Bool { get }
    
    func didAppear()
    func didDismiss()
}
