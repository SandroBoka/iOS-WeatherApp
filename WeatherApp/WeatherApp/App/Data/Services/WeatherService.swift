import Foundation
import Combine

protocol WeatherServiceProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<CurrentWeatherResponse, ClientError>) -> Void)
    func fetchExtraWeather(
        cityName: String,
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<ExtraWeatherResponse, ClientError>

}

class WeatherService: WeatherServiceProtocol {

    private let client: BaseApiClientProtocol
    private let endpointFactory: WeatherEndpointFactory

    init(client: BaseApiClientProtocol) {
        self.client = client

        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API Key not found") }

        endpointFactory = WeatherEndpointFactory(apiKey: apiKey)
    }

    func fetchWeather(
        for cityName: String,
        completion: @escaping (Result<CurrentWeatherResponse, ClientError>) -> Void
    ) {
        client.get(endpoint: endpointFactory.makeCurrentWeather(cityName: cityName)) { result in
            completion(result)
        }
    }

    func fetchExtraWeather(
        cityName: String,
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<ExtraWeatherResponse, ClientError> {
        let endpoint = endpointFactory.makeExtraWeather(cityName: cityName, latitude: latitude, longitude: longitude)

        return Future { [weak self] promise in
            self?.client.get(endpoint: endpoint) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }

}

private extension WeatherService {

    class WeatherEndpointFactory {

        private let apiKey: String

        init(apiKey: String) {
            self.apiKey = apiKey
        }

        func makeCurrentWeather(cityName: String) -> WeatherEndpoint {
            let queryItems = [
                URLQueryItem(name: "q", value: cityName),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")]

            return WeatherEndpoint(path: "/data/2.5/weather", queryItems: queryItems)
        }

        func makeExtraWeather(cityName: String, latitude: Double, longitude: Double) -> WeatherEndpoint {
            let queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "long", value: String(longitude)),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")]

            return WeatherEndpoint(path: "/data/3.0/onecall", queryItems: queryItems)
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
