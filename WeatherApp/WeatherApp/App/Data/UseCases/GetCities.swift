import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let dataRepository: LocationRepositoryProtocol

    init(dataRepository: LocationRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func getCities() -> [City] {
        dataRepository.getCities()
    }

}
