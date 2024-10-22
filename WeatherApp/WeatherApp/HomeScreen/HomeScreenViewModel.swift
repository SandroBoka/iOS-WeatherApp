import SwiftUI

class HomeScreenViewModel: ObservableObject {

    private let apiKey = "ff4cd4d2c654b4100a2712f4cbaeb732"

    @Published private(set) var weather: CurrentWeatherResponse?

    init() {
            Task {
                await fetchWeatherZagreb()
            }
        }

    func fetchWeatherZagreb() async {
        guard let urlComponentsCheck = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else { return }

        var urlComponents = urlComponentsCheck
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "Zagreb"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")]

        guard let url = urlComponents.url else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
            DispatchQueue.main.async { [weak self] in
                self?.weather = decodedData
            }
        } catch {
            print("Error fetching weather data: \(error)")
        }
    }

}
