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
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

struct GDSDemoScreenViewModel: GDSScreenViewModel {
    public let screenStyle: GDSScreenStyle
    public let body: [any ContentViewModel]
    public let movableFooter: [any ContentViewModel]
    public let footer: [any ContentViewModel]
    
    public init(
        screenStyle: GDSScreenStyle = .top,
        body: [any ContentViewModel],
        movableFooter: [any ContentViewModel],
        footer: [any ContentViewModel]
    ) {
        self.screenStyle = screenStyle
        self.body = body
        self.movableFooter = movableFooter
        self.footer = footer
    }
}
