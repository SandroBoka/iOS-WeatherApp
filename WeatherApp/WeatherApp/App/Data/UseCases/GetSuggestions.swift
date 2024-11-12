import Foundation

protocol GetSuggestionsUseCaseProtocol {

    func getSuggestedCities(prefix: String) -> [SuggestedCity]

}

class GetSuggestionsUseCase: GetSuggestionsUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getSuggestedCities(prefix: String) -> [SuggestedCity] {
        locationRepository.getSuggestions(prefix: prefix)
    }

}
