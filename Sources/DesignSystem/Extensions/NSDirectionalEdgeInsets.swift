import UIKit

extension NSDirectionalEdgeInsets {
    static let bodyStack = NSDirectionalEdgeInsets(
        top: DesignSystem.Spacing.small,
        leading: DesignSystem.Spacing.default,
        bottom: DesignSystem.Spacing.small,
        trailing: DesignSystem.Spacing.default
    )
    
    static let buttonStack = NSDirectionalEdgeInsets(
        top: 0,
        leading: DesignSystem.Spacing.default,
        bottom: DesignSystem.Spacing.default,
        trailing: DesignSystem.Spacing.default
    )
    
    static let separator = NSDirectionalEdgeInsets(
        top: 0,
        leading: DesignSystem.Spacing.default,
        bottom: DesignSystem.Spacing.small,
        trailing: 0
    )
}
