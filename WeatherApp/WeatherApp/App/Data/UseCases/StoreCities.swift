import Foundation

protocol StoreCitiesUseCaseProtocol {

    func storeCities(cities: [City])
    func storeCity(city: City)

}

class StoreCitiesUseCase: StoreCitiesUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func storeCities(cities: [City]) {
        locationRepository.storeCities(cities: cities)
    }

    func storeCity(city: City) {

    }

}
