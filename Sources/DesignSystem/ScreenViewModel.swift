public protocol ScreenViewModel {
    var body: [ContentItem] { get }
    var moveableFooter: [ContentItem] { get }
    var footer: [ContentItem] { get }
}
