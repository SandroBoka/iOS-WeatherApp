import Foundation
import Combine

public protocol WeatherServiceProtocol {

    func fetchWeather(cityName: String) -> AnyPublisher<CurrentWeatherResponse, ClientError>
    func fetchExtraWeather(latitude: Double, longitude: Double) -> AnyPublisher<ExtraWeatherResponse, ClientError>

}

public class WeatherService: WeatherServiceProtocol {

    private let client: BaseApiClientProtocol
    private let endpointFactory: WeatherEndpointFactory

    public init(client: BaseApiClientProtocol) {
        self.client = client

        guard let apiKey = InfoConstants.openWeatherMapApiKey else { fatalError("API Key not found") }

        endpointFactory = WeatherEndpointFactory(apiKey: apiKey)
    }

    public func fetchWeather(cityName: String) -> AnyPublisher<CurrentWeatherResponse, ClientError> {
        let endpoint = endpointFactory.makeCurrentWeather(cityName: cityName)

        return client.get(endpoint: endpoint)
            .eraseToAnyPublisher()
    }

    public func fetchExtraWeather(
        latitude: Double,
        longitude: Double) -> AnyPublisher<ExtraWeatherResponse, ClientError> {
        let endpoint = endpointFactory.makeExtraWeather(latitude: latitude, longitude: longitude)

        return client.get(endpoint: endpoint)
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

        func makeExtraWeather(latitude: Double, longitude: Double) -> WeatherEndpoint {
            let queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "exclude", value: "minutely"),
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
