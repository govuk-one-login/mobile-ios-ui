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
            font: DesignSystem.Font.bodySemiBold,
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
                normal: .systemGreen,
                focused: .yellow
            ),
            cornerRadius: DesignSystem.Spacing.default
        )
    }
}

extension GDSButtonStyle {
    public static var secondary: Self {
        GDSButtonStyle(
            config: .secondary,
            font: DesignSystem.Font.body,
            alignment: .center,
            foregroundColor: ColorForState(
                normal: .systemGreen,
                focused: .label
            ),
            backgroundColor: ColorForState(
                normal: .systemBackground,
                focused: .yellow
            ),
            cornerRadius: DesignSystem.Spacing.xSmall
        )
    }
}
