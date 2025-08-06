import Foundation
import UIKit

public typealias ExpandedContentTileViewModel = GDSContentTileViewModel &
                                                GDSContentTileViewModelWithImage &
                                                GDSContentTileViewModelWithDismissButton &
                                                GDSContentTileViewModelWithBody &
                                                GDSContentTileViewModelWithSecondaryButton &
                                                GDSContentTileViewModelWithPrimaryButton

@MainActor
public protocol GDSContentTileViewModel {
    var title: GDSLocalisedString { get }
    var titleFont: UIFont { get }
    var showSeparatorLine: Bool { get }
    var backgroundColour: UIColor? { get }
    var showShadow: Bool { get }
}

@MainActor
public protocol GDSContentTileViewModelWithImage {
    var image: UIImage { get }
    var caption: GDSLocalisedString? { get }
}

extension GDSContentTileViewModelWithImage {
    public var caption: GDSLocalisedString? {
        nil
    }
}

@MainActor
public protocol GDSContentTileViewModelWithDismissButton {
    var closeButtonAction: () -> Void { get }
}

@MainActor
public protocol GDSContentTileViewModelWithBody {
    var body: GDSLocalisedString { get }
}

@MainActor
public protocol GDSContentTileViewModelWithPrimaryButton {
    var primaryButtonViewModel: GDSButtonViewModel { get }
}

@MainActor
public protocol GDSContentTileViewModelWithSecondaryButton {
    var secondaryButtonViewModel: GDSButtonViewModel { get }
}

public struct FullGDSContentTile: ExpandedContentTileViewModel {
    public let title: GDSLocalisedString = "Content Tile"
    public let titleFont: UIFont = DesignSystem.Font.Base.bodySemiBold
    public let showSeparatorLine: Bool = true
    public let backgroundColour: UIColor? = .clear
    public let showShadow: Bool = true
    public let image: UIImage = UIImage(named: "DemoImage")!
    public let closeButtonAction: () -> Void = { print("close button pressed") }
    public let caption: GDSLocalisedString? = "image caption"
    public let body: GDSLocalisedString = "Content tile body description text"
    public let primaryButtonViewModel: GDSButtonViewModel = GDSButtonViewModel(
        title: "Button 1",
        style: .primary,
        buttonAction: .action({ print("button 1 pressed") })
    )
    public let secondaryButtonViewModel: GDSButtonViewModel = GDSButtonViewModel(
        title: "Button 2",
        style: .secondary,
        buttonAction: .action({ print("button 2 pressed") })
    )
    
    public init() { }
}

extension FullGDSContentTile: ContentItem {
    public var uiView: UIView {
        GDSContentTile(viewModel: self)
    }
}
