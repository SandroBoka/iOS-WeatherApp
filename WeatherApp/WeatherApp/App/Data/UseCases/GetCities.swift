import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getCities() -> [City] {
        locationRepository.getCities()
    }

}
