import Foundation
import Combine
import WeatherFramework

protocol GetSuggestionsUseCaseProtocol {

    func getSuggestedCities(prefix: String) -> AnyPublisher<[SuggestedCity], Error>

}

class GetSuggestionsUseCase: GetSuggestionsUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }

    func getSuggestedCities(prefix: String) -> AnyPublisher<[SuggestedCity], Error> {
        locationRepository.getSuggestions(prefix: prefix)
    }

}
