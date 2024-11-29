import SwiftUI
import Combine
import CoreLocation
import UserNotifications
import Weather

class CityListViewModel: ObservableObject {

    @Published private(set) var cities: [City] = []
    @Published private(set) var filteredCities: [City] = []
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
    private let userDefaultsUseCase: UserDefaultsUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    init(
        router: RouterProtocol,
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        removeCityUseCase: RemoveCityUseCaseProtocol,
        getSuggestionsUseCase: GetSuggestionsUseCaseProtocol,
        getIdUseCase: GetIdUseCaseProtocol,
        getLocationUseCase: GetLocationUseCaseProtocol,
        userDefaultsUseCase: UserDefaultsUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = getWeatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.removeCityUseCase = removeCityUseCase
        self.getSuggestionsUseCase = getSuggestionsUseCase
        self.getIdUseCase = getIdUseCase
        self.getLocationUseCase = getLocationUseCase
        self.userDefaultsUseCase = userDefaultsUseCase

        getLocationUseCase
            .isLocationEnabled()
            .receive(on: DispatchQueue.main)
            .assign(to: &$locationEnabled)

        getLocationUseCase
            .getCurrentCity()
            .catch { _ in Just("") }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cityName in
                guard let self else { return }

                self.currentCityName = cityName
                if self.locationEnabled {
                    self.addLocationCity()
                }
            }
            .store(in: &cancellables)

        updateCityList()

        $newCityName
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.getSuggestions(withPrefix: newValue)
            }
            .store(in: &cancellables)

        configureNotificationClick()
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
        guard !currentCityName.isEmpty else { return }

        print(currentCityName)
        getCityId(cityName: currentCityName)
            .sink { [weak self] id in
                guard let self else { return }

                guard id > 0 else { return }
                print(id)

                let newCity = City(id: id, name: self.currentCityName)
                userDefaultsUseCase.saveCurrentId(id: id)
                self.fetchTemperature(city: newCity)
            }
            .store(in: &cancellables)

        fetchWeatherAndScheduleNotification()
    }

    func removeCity(at offsets: IndexSet) {
        offsets.forEach { index in
            let cityList = locationEnabled ? filteredCities : cities
            if let cityToRemove = cityList.at(index) {
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

    func getCurrentCityId() -> Int {
        if !locationEnabled { return 0 }
        return userDefaultsUseCase.getCurrentId()
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

                self?.filteredCities = cities.filter({ $0.id != self?.getCurrentCityId() }).sorted { city1, city2 in
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
                return Just(-1)
            }
            .eraseToAnyPublisher()
    }

}

extension CityListViewModel {

    private func fetchWeatherAndScheduleNotification() {
        guard locationEnabled else { return }

        let currentCityId = getCurrentCityId()

        getWeatherUseCase
            .getWeather(cityId: currentCityId, cityName: currentCityName)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] weather in
                guard let self else { return }

                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

                let content = UNMutableNotificationContent()
                content.title = "Weather Update for \(self.currentCityName)"
                content.body = """
                Temperature: \(weather.hourlyForecast[1].temperature)°C
                \(weather.hourlyForecast[1].hourlyDescription.capitalized)
                """
                content.sound = UNNotificationSound.default
                content.userInfo = ["cityId": currentCityId, "cityName": currentCityName]

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            })
            .store(in: &cancellables)
    }

    private func configureNotificationClick() {
        NotificationCenter.default.publisher(for: .didReceiveNotificationForCity)
            .compactMap { $0.userInfo?["city"] as? City }
            .sink { [weak self] city in
                self?.showDetailsForCity(city: city)
            }
            .store(in: &cancellables)
    }

}
