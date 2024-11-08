import Foundation

protocol GetSuggestionsUseCaseProtocol {

    func getSuggestedCities(prefix: String) -> [SuggestedCity]

}

class GetSuggestionsUseCase: GetSuggestionsUseCaseProtocol {

    private let dataRepository: DataRepositoryProtocol

    init(dataRepository: DataRepositoryProtocol) {
        self.dataRepository = dataRepository
    }

    func getSuggestedCities(prefix: String) -> [SuggestedCity] {
        dataRepository.getSuggestions(prefix: prefix)
    }

}
