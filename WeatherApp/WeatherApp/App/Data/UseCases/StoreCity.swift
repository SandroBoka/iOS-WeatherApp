import Foundation

protocol StoreCityUseCaseProtocol {

    func storeCity(city: City)

}

class StoreCityUseCase: StoreCityUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func storeCity(city: City) {
        locationRepository.storeCity(city: city)
    }

}
