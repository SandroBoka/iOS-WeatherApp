import Foundation

enum ClientError: Error {

    case badURL
    case decodingError(Error)
    case networkError(Error)
    case httpError(Int)
    case noData
    case unknown

}

protocol BaseApiClientProtocol {

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

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(statusCode)
            else {
                completion(.failure(.httpError(statusCode)))
                return
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
