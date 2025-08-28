public protocol ScreenViewModel {
    var body: [any ContentViewModel] { get }
    var moveableFooter: [any ContentViewModel] { get }
    var footer: [any ContentViewModel] { get }
}
