public protocol ScreenViewModel {
    var content: [ContentItem] { get }
    var moveableFooter: [ContentItem] { get }
    var footer: [ContentItem] { get }
}
