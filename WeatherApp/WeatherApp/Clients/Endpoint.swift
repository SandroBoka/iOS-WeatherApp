import Foundation

public protocol Endpoint {

    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var baseURL: String { get }

}

extension Endpoint {

    func buildRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL + path)
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            return nil
        }

        return URLRequest(url: url)
    }
    
}

class WeatherEndpoint: Endpoint {

    var path: String
    var queryItems: [URLQueryItem]
    var baseURL = "https://api.openweathermap.org"

    init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }

}
