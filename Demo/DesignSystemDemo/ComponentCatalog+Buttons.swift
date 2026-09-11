@_spi(unstable) import DesignSystem
import UIKit

extension ComponentCatalog {

    // MARK: - Buttons

    static func buttons(present: @escaping (UIViewController) -> Void) -> [any ContentViewModel] {
        let controlledButton = button(
            title: TitleForState(normal: "Button enabled", disabled: "Button disabled"),
            style: .primary,
            enableState: false,
            action: .action({
                let alert = UIAlertController(title: "Enabled!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert)
            })
        )
        return [
            button(
                title: "Toggle button below",
                style: .primary,
                action: .action({ controlledButton.isEnabledToggle() })
            ),
            controlledButton,
            button(title: "Primary Button", style: .primary),
            button(title: "Secondary Button", style: .secondary),
            button(title: "Secondary Button with icon", icon: .arrowUpRight, style: .secondaryLeading),
            button(title: "Outline Button", style: .secondaryOutline),
            button(title: "Outline Button (with icon)", icon: .qrCode, style: .secondaryOutline)
        ]
    }

    /// Builds a demo button with the catalog's standard padding applied.
    private static func button(
        title: TitleForState,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        enableState: Bool? = nil,
        action: DesignSystem.Action = .action({ })
    ) -> GDSButtonViewModel {
        GDSButtonViewModel(
            title: title,
            icon: icon.map { IconForState(normal: $0) },
            style: style,
            buttonAction: action,
            enableState: enableState,
            verticalPadding: .vertical(8),
            horizontalPadding: .horizontal(16)
        )
    }

    private static func button(
        title: String,
        icon: IconStyle? = nil,
        style: GDSButtonStyle,
        action: DesignSystem.Action = .action({ })
    ) -> GDSButtonViewModel {
        button(
            title: TitleForState(stringLiteral: title),
            icon: icon,
            style: style,
            action: action
        )
    }
}
