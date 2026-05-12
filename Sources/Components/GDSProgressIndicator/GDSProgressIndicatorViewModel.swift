import UIKit

public struct GDSProgressIndicatorViewModel: ContentViewModel {
    public typealias ViewType = GDSProgressIndicator
    
    let title: GDSTextViewModel
    let titleAfter5Seconds: GDSTextViewModel
    let titleAfter10Seconds: GDSTextViewModel
    let progressIndicatorColor: UIColor
    
    public let verticalPadding: VerticalPadding?
    public let horizontalPadding: HorizontalPadding?
    
    public init(
        title: GDSTextViewModel = .init(title: GDSLocalisedString(stringKey: "defaultLoadingText", bundle: .designSystem)),
        titleAfter5Seconds: GDSTextViewModel = .init(title: GDSLocalisedString(stringKey: "fiveSecondLoadingText", bundle: .designSystem)),
        titleAfter10Seconds: GDSTextViewModel = .init(title: GDSLocalisedString(stringKey: "tenSecondLoadingText", bundle: .designSystem)),
        progressIndicatorColor: UIColor = DesignSystem.Color.Base.grey1,
        verticalPadding: VerticalPadding? = .vertical(DesignSystem.Spacing.default),
        horizontalPadding: HorizontalPadding? = .horizontal(DesignSystem.Spacing.default)
    ) {
        self.title = title
        self.titleAfter5Seconds = titleAfter5Seconds
        self.titleAfter10Seconds = titleAfter10Seconds
        self.progressIndicatorColor = progressIndicatorColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }
}
