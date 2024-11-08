import Foundation

protocol GetSuggestionsUseCaseProtocol {

    func getSuggestedCities(prefix: String) -> [CityObject]

}

class GetSuggestionsUseCase: GetSuggestionsUseCaseProtocol {

    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func getSuggestedCities(prefix: String) -> [CityObject] {
        dataRepository.getSuggestions(prefix: prefix)
    }

}
