import SwiftUI

class HomeScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let weatherService: WeatherServiceProtocol

    @Published var weather: WeatherModel?

    init(router: RouterProtocol, weatherService: WeatherServiceProtocol) {
        self.router = router
        self.weatherService = weatherService
    }

    func fetchWeatherZagreb() async {
        let city = "Zagreb"

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
