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

        updateCityList()

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
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }

                switch completion {
                case .finished:
                    self.updateCityList()
                    return
                case .failure(let error):
                    print("Error fetching weather with Combine: \(error)")
                }
            }, receiveValue: { _ in
                })
            .store(in: &cancellables)
    }

    func showDetailsForCity(city: City) {
        router.showCityWeather(city: city)
    }

    func addCity() {
        guard !newCityName.isEmpty else { return }

        let id = getCityId(cityName: newCityName)
        let newCity = City(id: id, name: newCityName)
        fetchTemperature(city: newCity)
        newCityName = ""
    }

    func removeCity(at offsets: IndexSet) {
        offsets.forEach { index in
            if let cityToRemove = cities.at(index) {
                removeCityUseCase.removeCityWeather(city: cityToRemove)
            }
        }
        updateCityList()
    }

    func getSuggestions(withPrefix prefix: String) {
        getSuggestionsUseCase.getSuggestedCities(prefix: prefix)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error getting suggestions: \(error)")
                }
            }, receiveValue: { [weak self] suggestions in
                self?.suggestedCities = suggestions
            })
            .store(in: &cancellables)
    }

    private func updateCityList() {
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
                self?.cities = cities.sorted { city1, city2 in
                    city1.name < city2.name
                }
            })
            .store(in: &cancellables)
    }

    private func getCityId(cityName: String) -> Int {
        var cityId = 0

        getIdUseCase.getCityId(cityName: cityName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching city id: \(error)")
                }
            }, receiveValue: { id in
                cityId = id
            })
            .store(in: &cancellables)

        return cityId
    }

}
