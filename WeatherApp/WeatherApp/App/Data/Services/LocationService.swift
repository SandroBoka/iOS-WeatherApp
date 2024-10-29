//import Foundation
//import Combine
//
//protocol LocationServiceProtocol {
//
//    func fetchLocation(for cityName: String, completion: @escaping (Result<LocationResponse, ClientError>) -> Void)
//
//}
//
//class LocationService: LocationServiceProtocol {
//
//    private let client: BaseApiClientProtocol
//
//    private let baseURL = 
//
//    init(client: BaseApiClientProtocol) {
//        self.client = client
//
//        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else { fatalError("API Key not found") }
//    }
//
//    func fetchLocation(for cityName: String, completion: @escaping (Result<LocationResponse, ClientError>) -> Void) {
//        <#code#>
//    }
//
//}
