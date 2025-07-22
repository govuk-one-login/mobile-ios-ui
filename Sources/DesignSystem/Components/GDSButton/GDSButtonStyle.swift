import UIKit

public struct GDSButtonStyle {
    public let config: UIButton.Configuration

    public let font: UIFont
    public let alignment: UIButton.Configuration.TitleAlignment
    public var contentInsets: NSDirectionalEdgeInsets?
    public let minimumHeight: CGFloat?

    public let foregroundColor: ColorForState
    public let backgroundColor: ColorForState

    public let cornerRadius: CGFloat
    public let border: BorderStyle?
    
    public var contentAlignment: UIControl.ContentHorizontalAlignment {
        switch alignment {
        case .leading:
                .leading
        case .trailing:
                .trailing
        default:
                .center
        }
    }
    
    public init(
        config: UIButton.Configuration,
        font: UIFont,
        alignment: UIButton.Configuration.TitleAlignment,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        minimumHeight: CGFloat? = 44,
        foregroundColor: ColorForState,
        backgroundColor: ColorForState,
        cornerRadius: CGFloat,
        border: BorderStyle? = nil
    ) {
        self.config = config
        self.font = font
        self.alignment = alignment
        self.contentInsets = contentInsets
        self.minimumHeight = minimumHeight
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
    }
}

extension GDSButtonStyle {
    public static var primary: Self {
        GDSButtonStyle(
            config: .primary,
            font: DesignSystem.Font.Base.bodySemiBold,
            alignment: .center,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.small,
                trailing: DesignSystem.Spacing.default
            ),
            foregroundColor: ColorForState(
                normal: .systemBackground,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Base.green2,
                focused: DesignSystem.Color.Base.yellow
            ),
            cornerRadius: DesignSystem.Spacing.default,
            border: nil
        )
    }
}

extension GDSButtonStyle {
    public static var primaryLarge: Self {
        GDSButtonStyle(
            config: .primary,
            font: DesignSystem.Font.Base.largeTitleBold,
            alignment: .center,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.small,
                trailing: DesignSystem.Spacing.default
            ),
            foregroundColor: ColorForState(
                normal: .systemBackground,
                focused: .label
            ),
            backgroundColor: ColorForState(
                normal: .systemRed,
                focused: DesignSystem.Color.Base.yellow
            ),
            cornerRadius: DesignSystem.Spacing.default,
            border: nil
        )
    }
}

extension GDSButtonStyle {
    public static var secondary: Self {
        GDSButtonStyle(
            config: .secondary,
            font: DesignSystem.Font.Base.body,
            alignment: .center,
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Base.green2,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: .systemBackground,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow
            ),
            cornerRadius: DesignSystem.Spacing.xSmall,
            border: nil
        )
    }
}

extension GDSButtonStyle {
    public static var secondarySmallLeading: Self {
        GDSButtonStyle(
            config: .secondary,
            font: DesignSystem.Font.Base.footnote,
            alignment: .leading,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: 0,
                bottom: DesignSystem.Spacing.small,
                trailing: 0
            ),
            minimumHeight: DesignSystem.Spacing.large,
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Base.green2,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: .systemBackground,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow
            ),
            cornerRadius: 4,
            border: nil
        )
    }
}
