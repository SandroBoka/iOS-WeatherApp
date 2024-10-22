import Foundation

protocol WeatherServiceProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<CurrentWeatherResponse, ClientError>) -> Void)

}

class WeatherService: WeatherServiceProtocol {

    private let client: BaseApiClientProtocol
    private let endpointFactory: WeatherEndpointFactory

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    init(client: BaseApiClientProtocol) {
        self.client = client

        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API Key not found") }

        endpointFactory = WeatherEndpointFactory(apiKey: apiKey)
    }

    func fetchWeather(
        for cityName: String,
        completion: @escaping (Result<CurrentWeatherResponse, ClientError>) -> Void
    ) {
        let queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")]

        let weatherEndpoint = WeatherEndpoint(path: "/data/2.5/weather", queryItems: queryItems)

        client.get(endpoint: endpointFactory.makeCurrentWeather(cityName: cityName)) { result in
            completion(result)
        }
    }


}

private extension WeatherService {

    class WeatherEndpointFactory {

        private let apiKey: String

        init(apiKey: String) {
            self.apiKey = apiKey
        }

        func makeCurrentWeather(cityName: String) -> WeatherEndpoint {

        }

    }

    struct WeatherEndpoint: Endpoint {

        var path: String
        var queryItems: [URLQueryItem]
        var baseURL = "https://api.openweathermap.org"

        init(path: String, queryItems: [URLQueryItem]) {
            self.path = path
            self.queryItems = queryItems
        }

    }

}
