import Foundation
import Combine
import Weather

protocol GetCurrentLocationUseCaseProtocol {

    func getCurrentCity() -> AnyPublisher<String, Error>
    func isLocationEnabled() -> AnyPublisher<Bool, Never>
    func requestLocation()

}

class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getCurrentCity() -> AnyPublisher<String, Error> {
        locationRepository.getCurrentCity()
    }

    func isLocationEnabled() -> AnyPublisher<Bool, Never> {
        locationRepository.isLocationEnabled()
    }

    func requestLocation() {
        locationRepository.requestLocation()
    }

}
