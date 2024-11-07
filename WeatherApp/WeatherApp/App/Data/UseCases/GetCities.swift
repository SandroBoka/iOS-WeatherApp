import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

<<<<<<< HEAD
    private let dataRepo: DataRepositoryProtocol

    init(dataRepo: DataRepositoryProtocol) {
        self.dataRepo = dataRepo
    }

    func getCities() -> [City] {
        return dataRepo.getCities()
=======
    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func getCities() -> [City] {
        dataRepository.getCities()
>>>>>>> develop
    }

}
