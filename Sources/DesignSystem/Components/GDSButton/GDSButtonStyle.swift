import UIKit

public struct GDSButtonStyle: Equatable {
    public let font: UIFont
    public let alignment: UIButton.Configuration.TitleAlignment
    public var contentInsets: NSDirectionalEdgeInsets?
    public let minimumHeight: CGFloat?

    public let foregroundColor: ColorForState
    public let backgroundColor: ColorForState

    public let cornerRadius: CGFloat
    public let border: BorderStyle?
    
    public init(
        font: UIFont,
        alignment: UIButton.Configuration.TitleAlignment,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        minimumHeight: CGFloat? = 44,
        foregroundColor: ColorForState,
        backgroundColor: ColorForState,
        cornerRadius: CGFloat,
        border: BorderStyle? = nil
    ) {
        self.font = font
        self.alignment = alignment
        self.contentInsets = contentInsets
        self.minimumHeight = minimumHeight
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
    }
    
    public func adjusting(
        font: UIFont? = nil,
        alignment: UIButton.Configuration.TitleAlignment? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        minimumHeight: CGFloat? = nil,
        foregroundColor: ColorForState? = nil,
        backgroundColor: ColorForState? = nil,
        cornerRadius: CGFloat? = nil,
        border: BorderStyle? = nil
    ) -> GDSButtonStyle {
        GDSButtonStyle(
            font: font ?? self.font,
            alignment: alignment ?? self.alignment,
            contentInsets: contentInsets ?? self.contentInsets,
            minimumHeight: minimumHeight ?? self.minimumHeight,
            foregroundColor: foregroundColor ?? self.foregroundColor,
            backgroundColor: backgroundColor ?? self.backgroundColor,
            cornerRadius: cornerRadius ?? self.cornerRadius,
            border: border ?? self.border
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    @_spi(unstable)
    public static var primary: Self {
        GDSButtonStyle(
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

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    @_spi(unstable)
    public static var destructive: Self {
        primary.adjusting(
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Base.red1,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow
            )
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    @_spi(unstable)
    public static var secondary: Self {
        GDSButtonStyle(
            font: DesignSystem.Font.Base.body,
            alignment: .center,
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Base.green1,
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
