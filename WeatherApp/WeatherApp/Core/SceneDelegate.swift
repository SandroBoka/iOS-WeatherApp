import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var dependencies = Dependencies()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        guard let window else { return }

        getCitiesFromJSON()
        dependencies.router.start(in: window)
    }

    private func getCitiesFromJSON() {
        let userDefaults = UserDefaults.standard
        let hasLoadedCitiesKey = "hasLoadedCities"

        if !userDefaults.bool(forKey: hasLoadedCitiesKey) && dependencies.realmService.getCitiesFromJson() {
            userDefaults.set(true, forKey: hasLoadedCitiesKey)
        }
    }

}
