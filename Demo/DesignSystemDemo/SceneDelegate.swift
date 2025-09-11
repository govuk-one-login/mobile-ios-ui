import UIKit
import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = GDSScreen(
            viewModel: GDSLeftAlignedScreenViewModel(
                body: [
                    GDSCardViewModel(
                        showShadow: true,
                        dismissAction: .action({ })
                    ) {
                        GDSCardTitleViewModel(
                            title: "A title for the component",
                            verticalPadding: .bottom(8),
                            horizontalPadding: .leading(16)
                        )
                        GDSCardTextViewModel(
                            title: "A subtitle for the componenet which can be used to describe it's purpose",
                            verticalPadding: .bottom(8)
                        )
                        GDSCardDividerViewModel(
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
                        GDSCardTextViewModel(
                            title: "A subtitle for the componenet which can be used to describe it's purpose",
                            verticalPadding: .bottom(8)
                        )
                        GDSCardDividerViewModel(
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
                ], movableFooter: [
                    GDSCardTextViewModel(title: "this is some footer text"),
                    GDSCardTextViewModel(title: "this is some more footer text")
                ],
                footer: [
                    GDSButtonViewModel(
                        title: "Primary Button",
                        style: .primary,
                        buttonAction: .action({})
                    )
                ]
            )
        ) // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
    }
}
