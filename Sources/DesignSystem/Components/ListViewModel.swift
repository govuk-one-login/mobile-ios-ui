import UIKit

public typealias TitleConfig = (font: UIFont, isHeader: Bool)

public enum ListStyle {
    case numbered
    case bulleted
}

@MainActor
public protocol ListViewModel: ContentViewModel {
    var title: GDSLocalisedString? { get }
    var titleConfig: TitleConfig? { get }
    var items: [GDSLocalisedString] { get }
    var style: ListStyle { get }
}
