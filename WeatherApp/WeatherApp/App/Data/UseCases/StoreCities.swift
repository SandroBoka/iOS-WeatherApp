import Foundation

protocol StoreCitiesUseCaseProtocol {

    func storeCities(cities: [City])

}

class StoreCitiesUseCase: StoreCitiesUseCaseProtocol {

    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func storeCities(cities: [City]) {
        dataRepository.storeCities(cities: cities)
    }

}
