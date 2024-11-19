import SwiftUI
import Combine
import CoreLocation

class CityListViewModel: ObservableObject {

    @Published private(set) var cities: [City] = []
    @Published var suggestedCities: [SuggestedCity] = []
    @Published var newCityName: String = ""
    @Published private(set) var currentCityName = ""
    @Published private(set) var locationEnabled: Bool = false

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let removeCityUseCase: RemoveCityUseCaseProtocol
    private let getSuggestionsUseCase: GetSuggestionsUseCaseProtocol
    private let getIdUseCase: GetIdUseCaseProtocol
    private let getLocationUseCase: GetLocationUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()
    private var newId = 0

    init(
        router: RouterProtocol,
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        removeCityUseCase: RemoveCityUseCaseProtocol,
        getSuggestionsUseCase: GetSuggestionsUseCaseProtocol,
        getIdUseCase: GetIdUseCaseProtocol,
        getLocationUseCase: GetLocationUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = getWeatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.removeCityUseCase = removeCityUseCase
        self.getSuggestionsUseCase = getSuggestionsUseCase
        self.getIdUseCase = getIdUseCase
        self.getLocationUseCase = getLocationUseCase

        getLocationUseCase
            .getCurrentCity()
            .catch { _ in Just("") }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cityName in
                guard let self else { return }

                self.currentCityName = cityName
                if self.locationEnabled {
                    self.addLocationCity()
                } else {
                    print("removing")
                    removeCityUseCase.removeCityWeather(city: City(id: 21, name: ""))
                }
            }
            .store(in: &cancellables)

        getLocationUseCase
            .isLocationEnabled()
            .receive(on: DispatchQueue.main)
            .assign(to: &$locationEnabled)

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

        getCityId(cityName: newCityName)
            .sink(receiveValue: { [weak self] id in
                guard let self else { return }

                let newCity = City(id: id, name: self.newCityName)
                self.fetchTemperature(city: newCity)
                self.newCityName = ""
            })
            .store(in: &cancellables)
    }

    func addLocationCity() {
        guard !currentCityName.isEmpty
        else { return }

        let newCity = City(id: 21, name: currentCityName)
        self.fetchTemperature(city: newCity)
    }

    func removeCity(at offsets: IndexSet) {
        offsets.forEach { index in
            var index = index
            if locationEnabled { index += 1 }
            if let cityToRemove = cities.at(index) {
                print(cityToRemove.name)
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

    func requestLocationAccess() {
        getLocationUseCase.requestLocation()
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

    private func getCityId(cityName: String) -> AnyPublisher<Int, Never> {
        getIdUseCase
            .getCityId(cityName: cityName)
            .catch { error -> Just<Int> in
                print("Error fetching city id: \(error)")
                return Just(0)
            }
            .eraseToAnyPublisher()
    }

}
