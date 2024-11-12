import Foundation

protocol GetIdUseCaseProtocol {

    func getCityId(cityName: String) -> Int

}

class GetIdUseCase: GetIdUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getCityId(cityName: String) -> Int {
        locationRepository.getCityId(cityName: cityName)
    }

}
