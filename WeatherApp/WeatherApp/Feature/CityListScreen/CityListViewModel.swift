import SwiftUI

class CityListViewModel: ObservableObject {

    @Published private(set) var cities: [City] = []
    @Published var suggestedCities: [SuggestedCity] = []

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let removeCityUseCase: RemoveCityUseCaseProtocol
    private let getSuggestionsUseCase: GetSuggestionsUseCaseProtocol

    init(
        router: RouterProtocol,
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        removeCityUseCase: RemoveCityUseCaseProtocol,
        getSuggestionsUseCase: GetSuggestionsUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = getWeatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.removeCityUseCase = removeCityUseCase
        self.getSuggestionsUseCase = getSuggestionsUseCase

        cities = getCitiesUseCase.getCities()
    }

    func fetchTemperature(for city: City) {
        getWeatherUseCase.getWeather(cityName: city.name) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let weatherModel):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.async { [weak self] in
                        self?.cities[index].temperature = weatherModel.temperature
                    }
                }
            case .failure(let error):
                print("Error fetching temperature for \(city.name): \(error)")
            }
        }
    }

    func showDetailsForCity(city: City) {
        router.showCityWeather(city: city)
    }

    func addCity(cityName: String) {
        let newCity = City(name: cityName)
        cities.append(newCity)
        fetchTemperature(for: newCity)
    }

    func removeCity(at offsets: IndexSet) {
        offsets.forEach { index in
            let cityToRemove = cities[index]
            removeCityUseCase.removeCityWeather(city: cityToRemove)
        }
        cities.remove(atOffsets: offsets)
    }

    func getSuggestions(withPrefix prefix: String) {
        suggestedCities = getSuggestionsUseCase.getSuggestedCities(prefix: prefix)
    }

}
