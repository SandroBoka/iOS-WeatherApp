import Foundation

protocol StoreCitiesUseCaseProtocol {

    func storeCities(cities: [City])

}

class StoreCitiesUseCase: StoreCitiesUseCaseProtocol {

    private let dataRepo: DataRepositoryProtocol

    init(dataRepo: DataRepositoryProtocol) {
        self.dataRepo = dataRepo
    }

    func storeCities(cities: [City]) {
        dataRepo.storeCities(cities: cities)
    }

}
