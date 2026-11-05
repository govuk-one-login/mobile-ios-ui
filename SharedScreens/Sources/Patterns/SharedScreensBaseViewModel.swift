import DesignSystem
import Foundation

@MainActor
public protocol SharedScreensBaseViewModel {
    var rightBarButtonTitle: GDSLocalisedString? { get }
    var backButtonIsHidden: Bool { get }
    
    func didAppear()
    func didDismiss()
}
