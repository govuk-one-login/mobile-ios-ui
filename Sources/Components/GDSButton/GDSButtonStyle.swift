import UIKit

public struct GDSButtonStyle: Equatable {
    /// Determines how wide a button is laid out within its container.
    public enum ContentFill: Equatable {
        /// The button stretches to fill the available width of its container. This is the default behaviour.
        case fill
        /// The button is only as wide as its content (title, icon and content insets).
        case hugContents
    }

    public let font: UIFont
    public let alignment: UIButton.Configuration.TitleAlignment
    public var contentInsets: NSDirectionalEdgeInsets?
    public let minimumHeight: CGFloat?

    public let foregroundColor: ColorForState
    public let backgroundColor: ColorForState

    /// Defaulted to `.capsule`. If `.fixed` `cornerStyle` is being used, ensure `cornerRadius` is also set
    public let cornerStyle: UIButton.Configuration.CornerStyle
    /// Only `.fixed` `cornerStyle` will respect `cornerRadius` set
    public let cornerRadius: CGFloat?
    public let border: BorderStyle?
    /// Controls whether the button fills its container width (default) or hugs its content.
    public let contentFill: ContentFill
    
    public init(
        font: UIFont,
        alignment: UIButton.Configuration.TitleAlignment,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        minimumHeight: CGFloat? = 44,
        foregroundColor: ColorForState,
        backgroundColor: ColorForState,
        cornerStyle: UIButton.Configuration.CornerStyle = .capsule,
        cornerRadius: CGFloat? = nil,
        border: BorderStyle? = nil,
        width: ContentFill = .fill
    ) {
        self.font = font
        self.alignment = alignment
        self.contentInsets = contentInsets
        self.minimumHeight = minimumHeight
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerStyle = cornerStyle
        self.cornerRadius = cornerRadius
        self.border = border
        self.contentFill = width
    }
    
    public func adjusting(
        font: UIFont? = nil,
        alignment: UIButton.Configuration.TitleAlignment? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        minimumHeight: CGFloat? = nil,
        foregroundColor: ColorForState? = nil,
        backgroundColor: ColorForState? = nil,
        cornerStyle: UIButton.Configuration.CornerStyle? = nil,
        cornerRadius: CGFloat? = nil,
        border: BorderStyle? = nil,
        contentFill: ContentFill? = nil
    ) -> GDSButtonStyle {
        GDSButtonStyle(
            font: font ?? self.font,
            alignment: alignment ?? self.alignment,
            contentInsets: contentInsets ?? self.contentInsets,
            minimumHeight: minimumHeight ?? self.minimumHeight,
            foregroundColor: foregroundColor ?? self.foregroundColor,
            backgroundColor: backgroundColor ?? self.backgroundColor,
            cornerStyle: cornerStyle ?? self.cornerStyle,
            cornerRadius: cornerRadius ?? self.cornerRadius,
            border: border ?? self.border,
            width: contentFill ?? self.contentFill
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
            cornerStyle: .capsule
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    public static var destructive: Self {
        primary.adjusting(
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.destructiveForeground,
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
    
    public static var secondaryDestructive: GDSButtonStyle {
        secondary.adjusting(
            foregroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.nativeButtonTextDestructive,
                highlighted: DesignSystem.Color.Buttons.destructiveNativeTextHighlighted,
                focused: DesignSystem.Color.Buttons.secondaryForegroundFocused
                
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                focused: DesignSystem.Color.Buttons.secondaryBackgroundFocused
            )
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
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
                highlighted: DesignSystem.Color.Buttons.secondaryForegroundHighlighted,
                focused: DesignSystem.Color.Buttons.secondaryForegroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryForegroundFocused
            ),
            backgroundColor: ColorForState(
                normal: .clear,
                focused: DesignSystem.Color.Buttons.secondaryBackgroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryBackgroundFocusedHighlighted
            ),
            cornerStyle: .fixed,
            cornerRadius: DesignSystem.Spacing.xSmall
        )
    }
    
    public static var secondaryOutline: Self {
        secondary.adjusting(
            alignment: .leading,
            backgroundColor: ColorForState(
                normal: DesignSystem.Color.Buttons.secondaryOutlinedBackground,
                focused: DesignSystem.Color.Buttons.secondaryBackgroundFocused,
                focusedHighlighted: DesignSystem.Color.Buttons.secondaryBackgroundFocusedHighlighted
            ),
            border: BorderStyle(width: 1, color: DesignSystem.Color.Buttons.secondaryForeground),
            contentFill: .hugContents
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
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
