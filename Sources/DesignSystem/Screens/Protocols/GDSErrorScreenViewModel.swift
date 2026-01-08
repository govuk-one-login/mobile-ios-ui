public protocol GDSErrorScreenViewModel: BaseViewModel, GDSScreenViewModel {
    var screenStyle: GDSScreenStyle { get }
    var body: [any ContentViewModel] { get }
    var movableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
    var rightBarButtonTitle: GDSLocalisedString? { get }
    var backButtonTitle: GDSLocalisedString? { get }
    var backButtonIsHidden: Bool { get }
    var didAppear: DesignSystem.Action? { get }
    var didDismiss: DesignSystem.Action? { get }
    
    var errorIcon: GDSImageViewModel? { get}
}

extension GDSErrorScreenViewModel {
    var bodyWithIcon: [any ContentViewModel] {
        if let icon = errorIcon {
            [icon] + body
        } else {
            body
        }
    }
}
