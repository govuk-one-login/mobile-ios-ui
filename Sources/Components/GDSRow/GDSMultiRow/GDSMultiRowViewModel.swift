import UIKit
public struct GDSMultiRowViewModel: ContentViewModel {
    public typealias ViewType = GDSMultiRow
    
    var rows: [GDSRowViewModel]
    var backgroundColor: UIColor
    var cornerRadius: CGFloat
    
    public var accessibilityIdentifier: String?
    public var accessibilityTraits: UIAccessibilityTraits?
    public var verticalPadding: VerticalPadding?
    public var horizontalPadding: HorizontalPadding?
    
    public init(
        rows: [GDSRowViewModel] = [],
        backgroundColor: UIColor = .secondarySystemBackground,
        cornerRadius: CGFloat = DesignSystem.CornerRadius.row,
        accessibilityIdentifier: String? = nil,
        accessibilityTraits: UIAccessibilityTraits? = nil,
        verticalPadding: VerticalPadding? = nil,
        horizontalPadding: HorizontalPadding? = nil
    ) {
        self.rows = rows
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityTraits = accessibilityTraits
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
