import Combine
import Foundation

public enum ClientError: Error {

    case badURL
    case decodingError(Error)
    case networkError(Error)
    case httpError(Int)
    case noData
    case unknown

}

public protocol BaseApiClientProtocol {

    func get<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, ClientError>

}

public class NetworkClient: BaseApiClientProtocol {

    public init() {

    }

    public func get<T>(endpoint: any Endpoint) -> AnyPublisher<T, ClientError> where T: Decodable {
        guard let request = endpoint.buildRequest() else {
            return Fail(error: ClientError.badURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { ClientError.networkError($0) }
            .tryMap { output in
                let statusCode = (output.response as? HTTPURLResponse)?.statusCode ?? -1
                guard (200...299).contains(statusCode) else { throw ClientError.httpError(statusCode) }

                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return ClientError.decodingError(decodingError)
                } else if let clientError = error as? ClientError {
                    return clientError
                } else {
                    return ClientError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

}
