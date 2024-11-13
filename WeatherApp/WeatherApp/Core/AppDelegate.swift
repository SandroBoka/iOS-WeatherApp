import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        getCitiesFromJSON()

        return true
    }

    private func getCitiesFromJSON() {
        let userDefaults = UserDefaults.standard
        let hasLoadedCitiesKey = "hasLoadedCities"

        if !userDefaults.bool(forKey: hasLoadedCitiesKey) && RealmService().loadCitiesFromJson() {
            userDefaults.set(true, forKey: hasLoadedCitiesKey)
        }
    }

}
