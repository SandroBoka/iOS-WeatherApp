import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: Router!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        router = Router(navigationController: UINavigationController())

        window = UIWindow(windowScene: windowScene)
        guard let window else { return }

        router.start(in: window)
    }

}
