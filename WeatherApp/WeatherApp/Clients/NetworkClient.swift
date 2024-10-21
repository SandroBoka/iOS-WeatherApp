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
    func get<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, ClientError>) -> Void)
}

class NetworkClient: BaseApiClientProtocol {

    func get<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, ClientError>) -> Void) {
        guard let request = endpoint.buildRequest() else {
            completion(.failure(.badURL))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                    return
                }
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
        }

        task.resume()
    }
}
