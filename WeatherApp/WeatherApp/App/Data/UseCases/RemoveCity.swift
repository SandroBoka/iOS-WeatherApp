import Foundation

protocol RemoveCityUseCaseProtocol {

    func removeCityWeather(city: City)
}

class RemoveCityUseCase: RemoveCityUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func removeCityWeather(city: City) {
        locationRepository.removeCityWeather(city: city)
    }

}
