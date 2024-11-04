import SwiftUI
import RealmSwift

class CityListViewModel: ObservableObject {

    @Published var cities: [City] = [] {
        didSet {
            storeCitiesUseCase.storeCities(cities: cities)
        }
    }

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let storeCitiesUseCase: StoreCitiesUseCaseProtocol

    init(
        router: RouterProtocol,
        weatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        storeCitiesUseCase: StoreCitiesUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = weatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.storeCitiesUseCase = storeCitiesUseCase

        cities = getCitiesUseCase.getCities()
        fetchWeatherForAllCities()
    }

    func fetchTemperature(for city: City) {
        getWeatherUseCase.getWeather(cityName: city.name) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherModel):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.sync { [weak self] in
                        self?.cities[index].temperature = weatherModel.temperature
                    }
                }
            case .failure(let error):
                print("Error fetching temperature for \(city.name): \(error)")
            }
        }
    }

    func fetchWeatherForAllCities() {
        for city in cities {
            fetchTemperature(for: city)
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
        cities.remove(atOffsets: offsets)
    }

}
