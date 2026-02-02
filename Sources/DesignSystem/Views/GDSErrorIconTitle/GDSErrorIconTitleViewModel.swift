import UIKit

public struct GDSErrorIconTitleViewModel: ContentViewModel {
    public typealias ViewType = GDSErrorIconTitle

    let icon: ErrorScreenIcon
    let iconHeight: CGFloat
    let errorTitle: GDSTextViewModel
    
    public var verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default)
    public var horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    public var renderedIconHeight: CGFloat {
        iconHeight + DesignSystem.Size.GDSErrorIcon.sfSymbolPadding
    }
    
    public var accessibilityLabel: String {
        "\(icon.voiceoverPrefix): \(errorTitle.title)"
    }

    public init(
        icon: ErrorScreenIcon,
        iconHeight: CGFloat = DesignSystem.Size.GDSErrorIcon.iconTargetHeight,
        errorTitle: GDSTextViewModel
    ) {
        self.icon = icon
        self.iconHeight = iconHeight
        self.errorTitle = errorTitle
    }
  
    public init(
        icon: ErrorScreenIcon,
        iconHeight: CGFloat = DesignSystem.Size.GDSErrorIcon.iconTargetHeight,
        title: GDSLocalisedString,
        titleFont: UIFont = DesignSystem.Font.Base.body,
        textColor: UIColor = DesignSystem.Color.Text.primary,
        alignment: NSTextAlignment = .left,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default),
        horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    ) {
        let titleViewModel = GDSTextViewModel(
            title: title,
            titleFont: titleFont,
            textColor: textColor,
            alignment: alignment,
            accessibilityTraits: accessibilityTraits,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
        )
        self.init(
            icon: icon,
            iconHeight: iconHeight,
            errorTitle: titleViewModel
        )
    }
}
