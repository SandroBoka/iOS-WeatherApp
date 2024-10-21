import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for cityName: String) async throws -> WeatherModel
}

class WeatherService: WeatherServiceProtocol {

    private let apiKey = "ff4cd4d2c654b4100a2712f4cbaeb732"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for cityName: String) async throws -> WeatherModel {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
        return decodedData
    }
}
