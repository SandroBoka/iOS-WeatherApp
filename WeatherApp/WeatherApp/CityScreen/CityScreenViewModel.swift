import SwiftUI

class CityScreenViewModel: ObservableObject {

    private let apiKey = "ff4cd4d2c654b4100a2712f4cbaeb732" // remove
    private let router: RouterProtocol

    @Published private(set) var city: String
    @Published private(set) var weather: WeatherModel?

    init(router: RouterProtocol, city: String) {
        self.router = router
        self.city = city
        Task {
            await fetchWeather()
        }
    }

    func fetchWeather() async {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")]

        guard let url = urlComponents.url else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
            DispatchQueue.main.async { [weak self] in
                self?.weather = decodedData
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
