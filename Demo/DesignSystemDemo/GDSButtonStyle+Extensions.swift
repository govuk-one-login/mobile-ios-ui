@_spi(unstable) import DesignSystem
import UIKit

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    static var secondaryLeading: Self {
        secondary.adjusting(
            alignment: .leading,
            contentInsets: NSDirectionalEdgeInsets(
                top: DesignSystem.Spacing.small,
                leading: 0,
                bottom: DesignSystem.Spacing.small,
                trailing: 0
            )
        )
    }
}

/// The design of specific button styles is not complete and are therefore subject to change
extension GDSButtonStyle {
    static var secondaryLeadingSmall: Self {
        secondaryLeading.adjusting(
            font: DesignSystem.Font.Base.footnote
        )
    }
}
