import DesignSystem
import UIKit

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
            viewModel: GDSDemoScreenViewModel(
                screenStyle: .centred,
                body: [],
                movableFooter: [],
                footer: []
            )
        ) // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
    }
}
