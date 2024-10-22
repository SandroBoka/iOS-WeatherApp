import SwiftUI

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let weatherService: WeatherServiceProtocol

    @Published var city: String
    @Published var weather: CurrentWeatherResponse?

    init(router: RouterProtocol, service: WeatherServiceProtocol, city: String) {
        self.router = router
        self.weatherService = service
        self.city = city
        Task {
            await fetchWeather()
        }
    }

    func fetchWeather() async {
        do {
            let decodedData = try await weatherService.fetchWeather(for: city)
            DispatchQueue.main.async { [ weak self ] in
                self?.weather = decodedData
            }
        } catch {
            print("Error fetching weather data: \(error)")
        }
    }

    func getWeatherWithCompletion() {
        weatherService.fetchWeather(for: city) { result in
            switch result {
            case .success(let weatherResponse):
                print("Weather: \(weatherResponse)")
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
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
