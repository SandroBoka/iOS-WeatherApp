import Foundation

protocol StoreCitiesUseCaseProtocol {

    func storeCities(cities: [City])

}

class StoreCitiesUseCase: StoreCitiesUseCaseProtocol {

    private let dataRepository: LocationRepositoryProtocol

    init(dataRepository: LocationRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func storeCities(cities: [City]) {
        dataRepository.storeCities(cities: cities)
    }

}
