import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let dataRepo: DataRepositoryProtocol

    init(dataRepo: DataRepositoryProtocol) {
        self.dataRepo = dataRepo
    }

    func getCities() -> [City] {
        return dataRepo.getCities()
    }
    
}
