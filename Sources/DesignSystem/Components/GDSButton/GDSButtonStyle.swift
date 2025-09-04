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
                normal: DesignSystem.Color.Buttons.primaryForeground,
                highlighted: DesignSystem.Color.Buttons.primaryForeground,
                focused: DesignSystem.Color.Buttons.primaryForegroundFocused,
                disabled: DesignSystem.Color.Buttons.primaryForegroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.primaryForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.primaryBackground,
                highlighted: DesignSystem.Color.Buttons.primaryBackgroundHighlighted,
                focused: DesignSystem.Color.Buttons.primaryBackgroundFocused,
                disabled: DesignSystem.Color.Buttons.primaryBackgroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.primaryBackgroundFocusedHighlighted
            ),
            cornerRadius: DesignSystem.CornerRadius.primaryButton
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    public static var destructive: Self {
        primary.adjusting(
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.destructiveForeground,
                highlighted: DesignSystem.Color.Buttons.destructiveForeground,
                focused: DesignSystem.Color.Buttons.destructiveForegroundFocused,
                disabled: DesignSystem.Color.Buttons.destructiveForegroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.destructiveForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.destructiveBackground,
                highlighted: DesignSystem.Color.Buttons.destructiveBackgroundHighlighted,
                focused: DesignSystem.Color.Buttons.destructiveBackgroundFocused,
                disabled: DesignSystem.Color.Buttons.destructiveBackgroundDisabled,
                focusedHighlighted: DesignSystem.Color.Buttons.destructiveBackgroundFocusedHighlighted
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
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.small,
                trailing: DesignSystem.Spacing.default
            ),
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.secondaryForeground,
                focused: DesignSystem.Color.Text.primary
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                highlighted: .systemGray6,
                focused: DesignSystem.Color.Base.yellow1
            ),
            cornerRadius: DesignSystem.Spacing.xSmall
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    @_spi(unstable)
    public static var dismiss: Self {
        secondary.adjusting(
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: DesignSystem.Spacing.default,
                bottom: DesignSystem.Spacing.xSmall,
                trailing: DesignSystem.Spacing.default
            ),
            minimumHeight: .zero
        )
    }
}
