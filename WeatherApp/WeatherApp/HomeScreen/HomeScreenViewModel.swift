import SwiftUI

class HomeScreenViewModel: ObservableObject {

    private let apiKey = "ff4cd4d2c654b4100a2712f4cbaeb732"
    @Published var weather: WeatherModel?

    func fetchWeatherZagreb() async {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "Zagreb"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = urlComponents.url else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
            DispatchQueue.main.async {
                self.weather = decodedData
            }
            print(decodedData)
        } catch {
            print("Error fetching weather data: \(error)")
        }
    }

}
