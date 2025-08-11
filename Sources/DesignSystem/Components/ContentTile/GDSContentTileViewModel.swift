import Foundation
import UIKit

public typealias ExpandedContentTileViewModel = GDSContentCardViewModel &
                                                GDSContentCardViewModelWithImage &
                                                GDSContentCardViewModelWithDismissButton &
                                                GDSContentCardViewModelWithBody &
                                                GDSContentCardViewModelWithSecondaryButton &
                                                GDSContentCardViewModelWithPrimaryButton

@MainActor
public protocol GDSContentCardViewModel {
    var title: GDSLocalisedString { get }
    var titleFont: UIFont { get }
    var showSeparatorLine: Bool { get }
    var backgroundColour: UIColor? { get }
    var applyShadow: Bool { get }
}

public extension GDSContentCardViewModel {
    var backgroundColour: UIColor? {
        .systemBackground
    }
}

@MainActor
public protocol GDSContentCardViewModelWithImage {
    var image: UIImage { get }
    var caption: GDSLocalisedString? { get }
}

public extension GDSContentCardViewModelWithImage {
    var caption: GDSLocalisedString? {
        nil
    }
}

@MainActor
public protocol GDSContentCardViewModelWithDismissButton {
    var closeButtonAction: () -> Void { get }
}

@MainActor
public protocol GDSContentCardViewModelWithBody {
    var body: GDSLocalisedString { get }
}

@MainActor
public protocol GDSContentCardViewModelWithPrimaryButton {
    var primaryButtonViewModel: GDSButtonViewModel { get }
}

@MainActor
public protocol GDSContentCardViewModelWithSecondaryButton {
    var secondaryButtonViewModel: GDSButtonViewModel { get }
}

public struct FullGDSContentCard: ExpandedContentTileViewModel {
    public let title: GDSLocalisedString = "Full Content Tile"
    public let titleFont: UIFont = DesignSystem.Font.Base.bodySemiBold
    public let showSeparatorLine: Bool = true
    public let applyShadow: Bool = true
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

extension FullGDSContentCard: ContentItem {
    public var uiView: UIView {
        GDSContentCard(viewModel: self)
    }
}

public struct PartialGDSContentCard: GDSContentCardViewModel &
                                     GDSContentCardViewModelWithDismissButton &
                                     GDSContentCardViewModelWithBody &
                                     GDSContentCardViewModelWithPrimaryButton {
    public let title: GDSLocalisedString = "Full Content Tile"
    public let titleFont: UIFont = DesignSystem.Font.Base.bodySemiBold
    public let showSeparatorLine: Bool = true
    public let applyShadow: Bool = true
    public let closeButtonAction: () -> Void = { print("close button pressed") }
    public let body: GDSLocalisedString = "Content tile body description text with extra text to demonstrate multi line"
    public let primaryButtonViewModel: GDSButtonViewModel = GDSButtonViewModel(
        title: "Button 1",
        style: .primary,
        buttonAction: .action({ print("button 1 pressed") })
    )
    
    public init() { }
}

extension PartialGDSContentCard: ContentItem {
    public var uiView: UIView {
        GDSContentCard(viewModel: self)
    }
}
