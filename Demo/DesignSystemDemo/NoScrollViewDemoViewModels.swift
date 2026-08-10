import DesignSystem
import UIKit

extension ViewController {
    var gdsNoScrollViewScreenViewModel: GDSDemoScreenViewModel {
        GDSDemoScreenViewModel(
            screenStyle: .noScrollView,
            body: [
                GDSTextViewModel(
                    title: "No Scroll View Screen",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .left
                ),
                GDSTextViewModel(
                    title: "This screen uses the .noScrollView style. Body content fills the available space without a scroll view wrapper — ideal for embedding a UICollectionView.", // swiftlint:disable:this line_length
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                )
            ],
            movableFooter: [],
            footer: [
                GDSButtonViewModel(
                    title: "Continue",
                    style: .primary,
                    buttonAction: .action({ }),
                    horizontalPadding: .horizontal(16)
                )
            ]
        )
    }

    var gdsCollectionViewScreenViewModel: GDSDemoScreenViewModel {
        let items = (1...30).map { "Item \($0)" }
        return GDSDemoScreenViewModel(
            screenStyle: .noScrollView,
            body: [
                GDSTextViewModel(
                    title: "Select an item",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .left
                ),
                GDSTextViewModel(
                    title: "Browse the list below and select the item that applies to you.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                DemoCollectionViewContentViewModel(items: items)
            ],
            movableFooter: [],
            footer: [
                GDSButtonViewModel(
                    title: "Continue",
                    style: .primary,
                    buttonAction: .action({ }),
                    horizontalPadding: .horizontal(16)
                )
            ]
        )
    }
}
