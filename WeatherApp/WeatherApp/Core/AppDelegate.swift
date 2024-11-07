import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let userDefaults = UserDefaults.standard
        let hasLoadedCitiesKey = "hasLoadedCities"

        if !userDefaults.bool(forKey: hasLoadedCitiesKey) {
            if RealmService().loadCitiesFromJson() {
                userDefaults.set(true, forKey: hasLoadedCitiesKey)
            }
        }

        return true
    }

}
