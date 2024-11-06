import SwiftUI

class CityListViewModel: ObservableObject {

<<<<<<< HEAD
    @Published var cities: [City] = [] {
        didSet {
            storeCitiesUseCase.storeCities(cities: cities)
        }
    }
=======
    @Published private(set) var cities: [City] = []
>>>>>>> develop

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let storeCitiesUseCase: StoreCitiesUseCaseProtocol

    init(
        router: RouterProtocol,
<<<<<<< HEAD
        weatherUseCase: GetWeatherUseCaseProtocol,
=======
        getWeatherUseCase: GetWeatherUseCaseProtocol,
>>>>>>> develop
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        storeCitiesUseCase: StoreCitiesUseCaseProtocol
    ) {
        self.router = router
<<<<<<< HEAD
        self.getWeatherUseCase = weatherUseCase
=======
        self.getWeatherUseCase = getWeatherUseCase
>>>>>>> develop
        self.getCitiesUseCase = getCitiesUseCase
        self.storeCitiesUseCase = storeCitiesUseCase

        cities = getCitiesUseCase.getCities()
        fetchWeatherForAllCities()
    }

    func fetchTemperature(for city: City) {
<<<<<<< HEAD
        getWeatherUseCase.getWeather(cityName: city.name) { [ weak self ] result in
            guard let self = self else { return }
=======
        getWeatherUseCase.getWeather(cityName: city.name) { [weak self] result in
            guard let self else { return }
>>>>>>> develop

            switch result {
            case .success(let weatherModel):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
<<<<<<< HEAD
                    DispatchQueue.main.sync { [ weak self ] in
                        self?.cities[index].temperature = weatherModel.temp
=======
                    DispatchQueue.main.sync { [weak self] in
                        self?.cities[index].temperature = weatherModel.temperature
>>>>>>> develop
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
<<<<<<< HEAD
=======
        storeCitiesUseCase.storeCities(cities: cities)
>>>>>>> develop
        fetchTemperature(for: newCity)
    }

    func removeCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
<<<<<<< HEAD
=======
        storeCitiesUseCase.storeCities(cities: cities)
>>>>>>> develop
    }

}
