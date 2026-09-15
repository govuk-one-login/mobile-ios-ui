import UIKit

/// Exposes a content view model's preference for how it should be sized and aligned
/// within its container. Used by `GDSScreen` to avoid stretching content-hugging
/// buttons to the full width of the screen.
@MainActor
protocol ContentFillProviding {
    /// `true` when the view should be laid out at its intrinsic content width
    /// rather than stretched to fill its container.
    var hugsContentWidth: Bool { get }
    /// The horizontal alignment to apply when hugging content width.
    var contentFillAlignment: UIStackView.Alignment { get }
}

public struct GDSButtonViewModel: ContentViewModel, ControlViewModel {
    
    public typealias ViewType = GDSButton
    
    public let title: TitleForState
    public let icon: IconForState?
    public let style: GDSButtonStyle
    public let buttonAction: DesignSystem.Action
    public let haptic: Haptic?
    public let accessibilityIdentifier: String?
    public let accessibilityHint: String?
    public let accessibilityTraits: UIAccessibilityTraits?
    public let enableState: EnableState?
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: String,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        buttonAction: DesignSystem.Action,
        haptic: Haptic? = nil,
        accessibilityIdentifier: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        enableState: Bool? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.title = TitleForState(stringLiteral: title)
        if let icon {
            self.icon = IconForState(normal: icon)
        } else {
            self.icon = nil
        }
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityHint = accessibilityHint
        self.accessibilityTraits = accessibilityTraits
        
        if let enableState {
            self.enableState = EnableState(enableState)
        } else {
            self.enableState = nil
        }
        
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
     
    public init(
        title: TitleForState,
        icon: IconForState? = nil,
        style: GDSButtonStyle,
        buttonAction: DesignSystem.Action,
        haptic: Haptic? = nil,
        accessibilityIdentifier: String? = nil,
        accessibilityHint: String? = nil,
        enableState: Bool? = nil,
        verticalPadding: VerticalPadding? = .vertical(0),
        horizontalPadding: HorizontalPadding? = .horizontal(0)
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.buttonAction = buttonAction
        self.haptic = haptic
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityHint = accessibilityHint
        self.accessibilityTraits = nil
        
        if let enableState {
            self.enableState = EnableState(enableState)
        } else {
            self.enableState = nil
        }
        
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}

extension GDSButtonViewModel: ContentFillProviding {
    var hugsContentWidth: Bool {
        style.contentFill == .hugContents
    }

    var contentFillAlignment: UIStackView.Alignment {
        switch style.alignment {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }
}
