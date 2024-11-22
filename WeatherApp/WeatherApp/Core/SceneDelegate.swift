import SwiftUI
import UserNotifications
import Weather

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

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

        dependencies.getLocationUseCase.requestLocation()
        requestNotificationPermission()
        setupNotificationDelegate()
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

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }

    private func setupNotificationDelegate() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
}

extension SceneDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let cityId = userInfo["cityId"] as? Int, let cityName = userInfo["cityName"] as? String {
            let city = City(id: cityId, name: cityName)

            NotificationCenter.default.post(
                name: .didReceiveNotificationForCity,
                object: nil,
                userInfo: ["city": city]
            )
        }
        completionHandler()
    }

}

extension Notification.Name {

    static let didReceiveNotificationForCity = Notification.Name("didReceiveNotificationForCity")

}
