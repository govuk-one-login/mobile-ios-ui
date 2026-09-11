@_spi(unstable) import DesignSystem
import UIKit

/// Groups the design system example content by category so each category can be
/// rendered on its own screen. Content that needs to present UIKit alerts is
/// supplied a `present` closure by the hosting controller.
@MainActor
enum ComponentCatalog {

    // MARK: - Buttons

    static func buttons(present: @escaping (UIViewController) -> Void) -> [any ContentViewModel] {
        let controlledButton = GDSButtonViewModel(
            title: TitleForState(normal: "Button enabled", disabled: "Button disabled"),
            style: .primary,
            buttonAction: .action({
                let alert = UIAlertController(title: "Enabled!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert)
            }),
            enableState: false
        )
        return [
            GDSButtonViewModel(
                title: "Toggle button below",
                style: .primary,
                buttonAction: .action({
                    controlledButton.isEnabledToggle()
                })
            ),
            controlledButton,
            GDSButtonViewModel(
                title: "Primary Button",
                style: .primary,
                buttonAction: .action({ })
            ),
            GDSButtonViewModel(
                title: "Secondary Button",
                style: .secondary,
                buttonAction: .action({ })
            ),
            GDSButtonViewModel(
                title: "Secondary Button with icon",
                icon: .arrowUpRight,
                style: .secondaryLeading,
                buttonAction: .action({ })
            )
        ]
    }

    // MARK: - Progress Indicator

    static var progressIndicators: [any ContentViewModel] {
        [
            GDSTextViewModel(
                title: "Progress indicator",
                titleFont: DesignSystem.Font.Base.title3Bold,
                alignment: .left
            ),
            GDSProgressIndicatorViewModel()
        ]
    }

    // MARK: - Text

    static var text: [any ContentViewModel] {
        [
            GDSTextViewModel(
                title: "Simple test label",
                titleFont: DesignSystem.Font.Base.body,
                alignment: .left
            ),
            GDSTextViewModel(
                title: "Bold title label",
                titleFont: DesignSystem.Font.Base.title1Bold,
                alignment: .left
            ),
            GDSTextViewModel(
                title: "Centred label",
                titleFont: DesignSystem.Font.Base.body,
                alignment: .center
            )
        ]
    }

    // MARK: - Error Icons

    static var errorIcons: [any ContentViewModel] {
        [
            GDSErrorIconTitleViewModel(
                icon: .error,
                errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: .header,
                    verticalPadding: .bottom(8)
                )
            ),
            GDSErrorIconTitleViewModel(
                icon: .warning,
                errorTitle: GDSTextViewModel(
                    title: "There is a problem",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    alignment: .center,
                    accessibilityTraits: UIAccessibilityTraits.none,
                    verticalPadding: .bottom(8)
                )
            )
        ]
    }

    // MARK: - Rows

    static var rows: [any ContentViewModel] {
        [
            GDSMultiRowViewModel(rows: [
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 1"),
                    detailConfig: StyledText(text: "20"),
                    iconStyle: IconStyle(icon: "chevron.right"),
                    type: .regular
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 2", colour: .red),
                    subtitleConfig: StyledText(text: "Test Subtitle"),
                    detailConfig: StyledText(text: "14"),
                    image: UIImage(named: "exampleImage"),
                    iconStyle: IconStyle(
                        icon: "arrow.up.right",
                        colour: .blue,
                        accessibilityHint: "this is icon alt text"
                    )
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 3"),
                    image: UIImage(named: "vetCard"),
                    iconStyle: .arrowUpRight,
                    action: .action(
                        {
                            UIApplication.shared.open(URL(string: "https://www.google.com")!)
                        }
                    )
                ),
                GDSRowViewModel(
                    titleConfig: StyledText(text: "Test Title Label 4")
                )
            ])
        ]
    }

    // MARK: - Lists

    static var lists: [any ContentViewModel] {
        [
            GDSListViewModel(
                title: "Numbered List",
                titleConfig: (font: DesignSystem.Font.Base.title3Bold, isHeader: true),
                items: [
                    "take a photo",
                    GDSLocalisedString(
                        stringKey: "This is bold, this is not",
                        stringAttributes: [("This is bold",
                                            [.font: UIFont(.body, weight: .bold)])]
                    ),
                    "Item 2",
                    "Item 3"
                ],
                style: .numbered
            ),
            GDSListViewModel(
                title: "Bulleted List",
                titleConfig: (font: DesignSystem.Font.Base.body, isHeader: false),
                items: [
                    "take a photo",
                    GDSLocalisedString(
                        stringLiteral: "second numbered list item",
                        stringAttributes: [("numbered list", [.font: DesignSystem.Font.Base.bodyBold])]
                    ),
                    "Item 3"
                ],
                style: .bulleted
            ),
            GDSListViewModel(
                items: [
                    GDSLocalisedString(
                        stringLiteral: "Item 1 - this is an example of a numbered list without a title, long texts should wrap!",
                        stringAttributes: [("wrap!", [.font: DesignSystem.Font.Base.bodyBold])]
                    ),
                    "Item 2",
                    "Item 3"
                ],
                style: .numbered
            ),
            GDSListViewModel(
                items: [
                    "Item 1",
                    GDSLocalisedString(
                        stringKey: "second bulleted list item",
                        stringAttributes: [("numbered list", [.font: DesignSystem.Font.Base.bodyBold])]
                    ),
                    "Item 3"
                ],
                style: .bulleted
            )
        ]
    }

    // MARK: - Cards

    static var cards: [any ContentViewModel] {
        [
            GDSCardViewModel(
                showShadow: true,
                dismissAction: .action({ })
            ) {
                GDSImageViewModel(
                    image: UIImage(named: "placeholder") ?? UIImage(),
                    contentMode: .scaleAspectFit
                )
                GDSTextViewModel(
                    title: GDSLocalisedString(
                        stringLiteral: "Here is the caption for the picture",
                        stringAttributes: [("Here is the caption for the picture",
                                            [.foregroundColor: DesignSystem.Color.Icons.success])]
                    ),
                    verticalPadding: .vertical(8)
                )
                GDSTextViewModel(
                    title: "A title for the component for a quick introduction",
                    titleFont: DesignSystem.Font.Base.title1Bold,
                    verticalPadding: .bottom(8)
                )
                GDSTextViewModel(
                    title: "A subtitle for the componenet which can be used to describe it's purpose",
                    verticalPadding: .bottom(8)
                )
                GDSDividerViewModel(
                    verticalPadding: .bottom(8)
                )
                GDSButtonViewModel(
                    title: "Secondary Button",
                    style: .secondary,
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(8),
                    horizontalPadding: .horizontal(16)
                )
                GDSButtonViewModel(
                    title: "Primary Button",
                    style: .primary,
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(16),
                    horizontalPadding: .horizontal(16)
                )
            },
            GDSCardViewModel(
                showShadow: true,
                dismissAction: .action({ })
            ) {
                GDSCardTitleViewModel(
                    title: "A title for the component",
                    verticalPadding: .bottom(8),
                    horizontalPadding: .leading(16)
                )
                GDSTextViewModel(
                    title: "A subtitle for the componenet which can be used to describe it's purpose",
                    verticalPadding: .bottom(8)
                )
                GDSDividerViewModel(
                    verticalPadding: .bottom(8)
                )
                GDSButtonViewModel(
                    title: "Secondary Button",
                    icon: .arrowUpRight,
                    style: .secondary.adjusting(
                        alignment: .leading,
                        contentInsets: NSDirectionalEdgeInsets(
                            top: DesignSystem.Spacing.small,
                            leading: .zero,
                            bottom: DesignSystem.Spacing.small,
                            trailing: DesignSystem.Spacing.default
                        )
                    ),
                    buttonAction: .action({ }),
                    verticalPadding: .bottom(8),
                    horizontalPadding: .horizontal(16)
                )
            }
        ]
    }
}
