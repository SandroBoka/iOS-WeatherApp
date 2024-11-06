import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func getCities() -> [City] {
        dataRepository.getCities()
    }

}
