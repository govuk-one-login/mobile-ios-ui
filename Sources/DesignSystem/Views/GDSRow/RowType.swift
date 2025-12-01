import UIKit

public enum RowType {
    case regular
    case tall
    
    public var minRowHeight: CGFloat {
        switch self {
        case .regular:
            DesignSystem.Size.GDSRow.regularHeight
        case .tall:
            DesignSystem.Size.GDSRow.tallHeight
        }
    }
    
    public var subtitleFont: UIFont {
        switch self {
        case .regular:
            DesignSystem.Font.Base.footnote
        case .tall:
            DesignSystem.Font.Base.subheadline
        }
    }
    
    public var subtitleColour: UIColor {
        switch self {
        case .regular:
            DesignSystem.Color.GDSRow.regSubtitle
        case .tall:
            DesignSystem.Color.GDSRow.tallSubtitle
        }
    }
    
    public func verticalPadding(hasSubtitle: Bool) -> CGFloat {
        switch (self, hasSubtitle) {
        case (.regular, true): DesignSystem.Spacing.GDSRow.regularWithSubtitle
        case (.regular, false): DesignSystem.Spacing.GDSRow.regularWithoutSubtitle
        case (.tall, true): DesignSystem.Spacing.GDSRow.tallWithSubtitle
        case (.tall, false): DesignSystem.Spacing.GDSRow.tallWithoutSubtitle
        }
    }
}
