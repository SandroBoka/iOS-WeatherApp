import Foundation

enum InfoConstants {

    static var openWeatherMapApiKey: String? {
        Bundle.main.infoDictionary?["API_KEY"] as? String
    }

}
