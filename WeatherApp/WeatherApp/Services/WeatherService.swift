import Foundation

protocol WeatherServiceProtocol {

    func fetchWeather(for cityName: String) async throws -> CurrentWeatherResponse

}

class WeatherService: WeatherServiceProtocol {

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    private var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { return "API Key not found" }

        return apiKey
    }

    func fetchWeather(for cityName: String) async throws -> CurrentWeatherResponse {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")]

        guard let url = urlComponents.url else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
        return decodedData
    }

}
