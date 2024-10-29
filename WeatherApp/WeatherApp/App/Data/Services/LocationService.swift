import Foundation
import Combine

protocol LocationServiceProtocol {

    func fetchLocation(for cityName: String, completion: @escaping (Result<LocationResponse, ClientError>) -> Void)

}

class LocationService: LocationServiceProtocol {

    private let client: BaseApiClientProtocol
    private let endPointFactory: LocationEndpointFactory

    init(client: BaseApiClientProtocol) {
        self.client = client

        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API Key not found") }

        endPointFactory = LocationEndpointFactory(apiKey: apiKey)
    }

    func fetchLocation(for cityName: String, completion: @escaping (Result<LocationResponse, ClientError>) -> Void) {
        client.get(endpoint: endPointFactory.makeLocationEndpoint(cityName: cityName)) { result in
            completion(result)
        }
    }

}

private extension LocationService {

    class LocationEndpointFactory {

        private let apiKey: String

        init(apiKey: String) {
            self.apiKey = apiKey
        }

        func makeLocationEndpoint(cityName: String) -> LocationEndpoint {
            let queryItems = [
                URLQueryItem(name: "q", value: cityName),
                URLQueryItem(name: "limit", value: "1"),
                URLQueryItem(name: "appid", value: apiKey)]

            return LocationEndpoint(path: "/geo/1.0/direct", queryItems: queryItems)
        }

    }

    struct LocationEndpoint: Endpoint {

        var path: String
        var queryItems: [URLQueryItem]
        var baseURL = "https://api.openweathermap.org"

        init(path: String, queryItems: [URLQueryItem]) {
            self.path = path
            self.queryItems = queryItems
        }

    }

}
