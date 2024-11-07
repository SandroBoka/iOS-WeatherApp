import Foundation

protocol StoreCitiesUseCaseProtocol {

    func storeCities(cities: [City])

}

class StoreCitiesUseCase: StoreCitiesUseCaseProtocol {

<<<<<<< HEAD
    private let dataRepo: DataRepositoryProtocol

    init(dataRepo: DataRepositoryProtocol) {
        self.dataRepo = dataRepo
    }

    func storeCities(cities: [City]) {
        dataRepo.storeCities(cities: cities)
=======
    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func storeCities(cities: [City]) {
        dataRepository.storeCities(cities: cities)
>>>>>>> develop
    }

}
