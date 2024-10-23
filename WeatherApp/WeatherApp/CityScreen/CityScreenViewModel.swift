import SwiftUI

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let weatherRepo: WeatherRepositoryProtocol

    @Published var city: String
    @Published var weather: WeatherModel?

    init(router: RouterProtocol, repo: WeatherRepositoryProtocol, city: String) {
        self.router = router
        self.weatherRepo = repo
        self.city = city

        fetchWeather()
    }

    func fetchWeather() {
        weatherRepo.fetchWeather(for: city) { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async { [ weak self ] in
                    self?.weather = weatherModel
                }
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
