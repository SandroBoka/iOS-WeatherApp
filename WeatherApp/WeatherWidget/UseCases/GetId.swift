import Foundation
import Combine
import Weather

protocol GetCurrentLocationIdUseCaseProtocol {

    func getId(cityName: String) -> AnyPublisher<Int, Error>

}

class GetCurrentLocationIdUseCase: GetCurrentLocationIdUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getId(cityName: String) -> AnyPublisher<Int, Error> {
        locationRepository.getCityId(cityName: cityName)
    }

}
