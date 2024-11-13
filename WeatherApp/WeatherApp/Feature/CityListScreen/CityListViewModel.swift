import SwiftUI
import Combine

class CityListViewModel: ObservableObject {

    @Published private(set) var cities: [City] = []
    @Published var suggestedCities: [SuggestedCity] = []
    @Published var newCityName: String = ""

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let removeCityUseCase: RemoveCityUseCaseProtocol
    private let getSuggestionsUseCase: GetSuggestionsUseCaseProtocol
    private let getIdUseCase: GetIdUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    init(
        router: RouterProtocol,
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        removeCityUseCase: RemoveCityUseCaseProtocol,
        getSuggestionsUseCase: GetSuggestionsUseCaseProtocol,
        getIdUseCase: GetIdUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = getWeatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.removeCityUseCase = removeCityUseCase
        self.getSuggestionsUseCase = getSuggestionsUseCase
        self.getIdUseCase = getIdUseCase

        getCitiesUseCase.getCities()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching cities: \(error)")
                }
            }, receiveValue: { [weak self] cities in
                self?.cities = cities
            })
            .store(in: &cancellables)

        $newCityName
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.getSuggestions(withPrefix: newValue)
            }
            .store(in: &cancellables)
    }

    func fetchTemperature(city: City) {
        getWeatherUseCase.getWeather(cityId: city.id, cityName: city.name)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error fetching weather with Combine: \(error)")
                }
            }, receiveValue: { weatherModel in
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.async { [weak self] in
                        self?.cities[index].temperature = weatherModel.temperature
                    }
                }
            })
            .store(in: &cancellables)
    }

    func showDetailsForCity(city: City) {
        router.showCityWeather(city: city)
    }

    func addCity() {
        guard !newCityName.isEmpty else { return }

        let id = getIdUseCase.getCityId(cityName: newCityName)
        let newCity = City(id: id, name: newCityName)
        cities.append(newCity)
        fetchTemperature(city: newCity)
        newCityName = ""
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
