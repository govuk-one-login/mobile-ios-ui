import DesignSystem
import UIKit

// MARK: - Footer resizing example

extension ViewController {
    /// Exercises how the footer behaves as Dynamic Type changes. The footer scales
    /// with the text; once the whole footer would take up more than a third of the
    /// screen, the movable content moves into the scrolling content, and returns
    /// when the text size shrinks again.
    var gdsFooterResizingScreenViewModel: GDSDemoScreenViewModel {
        GDSDemoScreenViewModel(
            body: [
                GDSTextViewModel(
                    title: "Footer Resizing",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .left
                ),
                GDSTextViewModel(
                    title: "Change the text size and watch the footer. It should grow and shrink with the text, without overlapping the content above.", // swiftlint:disable:this line_length
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                GDSListViewModel(
                    title: "Things to check",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "The spacing between footer items scales with the text",
                        "No footer content is clipped or overlapping",
                        "At large sizes the movable footer content moves into this scrolling content",
                        "At smaller sizes it returns to the footer, with the same spacing as before"
                    ],
                    style: .numbered
                ),
                GDSTextViewModel(
                    title: "Extra content so there is enough here to scroll.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                GDSListViewModel(
                    title: "More content",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: (1...8).map { GDSLocalisedString(stringLiteral: "Body item \($0)") },
                    style: .bulleted
                )
            ],
            movableFooter: [
                GDSTextViewModel(
                    title: "Review the following before you continue.",
                    titleFont: DesignSystem.Font.Base.subheadline,
                    alignment: .left,
                    verticalPadding: .bottom(DesignSystem.Spacing.small),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                ),
                GDSButtonViewModel(
                    title: "Terms and conditions",
                    icon: .arrowUpRight,
                    style: .secondaryLeading,
                    buttonAction: .action({ }),
                    verticalPadding: .vertical(.zero),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                ),
                GDSButtonViewModel(
                    title: "Privacy notice",
                    icon: .arrowUpRight,
                    style: .secondaryLeading,
                    buttonAction: .action({ }),
                    verticalPadding: .vertical(.zero),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                )
            ],
            footer: [
                GDSButtonViewModel(
                    title: "Add to wallet",
                    style: .primary,
                    buttonAction: .action({ }),
                    verticalPadding: .top(DesignSystem.Spacing.small),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                )
            ],
            footerBackgroundColor: .secondarySystemBackground
        )
    }
}

// MARK: - Landscape split layout example

extension ViewController {
    /// Rotate to landscape (iPhone) to see the body scroll on the leading half and
    /// the footer fixed on the trailing half. Increase Dynamic Type to push the
    /// movable footer back into the scrolling content.
    var gdsLandscapeScreenViewModel: GDSDemoScreenViewModel {
        GDSDemoScreenViewModel(
            body: [
                GDSTextViewModel(
                    title: "Landscape Split Layout",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .left
                ),
                GDSTextViewModel(
                    title: "Rotate to landscape: this content scrolls on the left while the footer stays fixed on the right.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                GDSListViewModel(
                    title: "Things to try",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: [
                        "Rotate between portrait and landscape",
                        "Increase Dynamic Type until the footer no longer fits",
                        "Scroll the body on the left",
                        "Check the notch side in both landscape directions"
                    ],
                    style: .numbered
                ),
                GDSTextViewModel(
                    title: "Extra body content so the scroll view has something to scroll.",
                    titleFont: DesignSystem.Font.Base.body,
                    alignment: .left
                ),
                GDSListViewModel(
                    title: "More content",
                    titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                    items: (1...8).map { GDSLocalisedString(stringLiteral: "Body item \($0)") },
                    style: .bulleted
                )
            ],
            movableFooter: [
                GDSTextViewModel(
                    title: "Review the following before you continue.",
                    titleFont: DesignSystem.Font.Base.subheadline,
                    alignment: .left,
                    verticalPadding: .bottom(DesignSystem.Spacing.small),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                ),
                GDSButtonViewModel(
                    title: "Terms and conditions",
                    icon: .arrowUpRight,
                    style: .secondaryLeading,
                    buttonAction: .action({ }),
                    verticalPadding: .vertical(.zero),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                ),
                GDSButtonViewModel(
                    title: "Privacy notice",
                    icon: .arrowUpRight,
                    style: .secondaryLeading,
                    buttonAction: .action({ }),
                    verticalPadding: .vertical(.zero),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                )
            ],
            footer: [
                GDSButtonViewModel(
                    title: "Add to wallet",
                    style: .primary,
                    buttonAction: .action({ }),
                    verticalPadding: .top(DesignSystem.Spacing.small),
                    horizontalPadding: .horizontal(DesignSystem.Spacing.default)
                )
            ],
            footerBackgroundColor: .secondarySystemBackground
        )
    }
}
