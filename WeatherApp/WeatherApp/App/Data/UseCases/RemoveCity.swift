import Foundation

protocol RemoveCityUseCaseProtocol {

    func removeCity(city: City)
}

class RemoveCityUseCase: RemoveCityUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func removeCity(city: City) {
        locationRepository.removeCity(city: city)
    }

}
