import SwiftUI

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let weatherService: WeatherServiceProtocol

    @Published var city: String
    @Published var weather: WeatherModel?

    init(router: RouterProtocol, service: WeatherServiceProtocol, city: String) {
        self.router = router
        self.weatherService = service
        self.city = city
    }

    func fetchWeather() async {
        do {
            let decodedData = try await weatherService.fetchWeather(for: city)
            DispatchQueue.main.async {
                self.weather = decodedData
            }
        } catch {
            print("Error fetching weather data: \(error)")
        }
    }

    func formatTimeFromUnix(_ unixTime: Int, timeZoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime + timeZoneOffset))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter.string(from: date)
    }

}
