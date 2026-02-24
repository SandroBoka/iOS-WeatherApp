import Foundation
import Combine
import Weather

protocol GetIdUseCaseProtocol {

    func getCityId(cityName: String) -> AnyPublisher<Int, Error>

}

class GetIdUseCase: GetIdUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getCityId(cityName: String) -> AnyPublisher<Int, Error> {
        locationRepository.getCityId(cityName: cityName)
    }

}
