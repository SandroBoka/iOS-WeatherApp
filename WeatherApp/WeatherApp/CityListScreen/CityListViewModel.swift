import SwiftUI

class CityListViewModel: ObservableObject {

    @Published var cities: [City] = [
        City(name: "Zagreb"),
        City(name: "Paris"),
        City(name: "New York"),
        City(name: "Tokyo"),
        City(name: "London"),
        City(name: "Los Angeles"),
        City(name: "Toronto"),
        City(name: "Split")]

    private let router: RouterProtocol
    private let weatherService: WeatherServiceProtocol

    init(router: RouterProtocol, service: WeatherServiceProtocol) {
        self.router = router
        self.weatherService = service

        fetchWeatherForAllCities()
    }

    func fetchTemperature(for city: City) {
        weatherService.fetchWeather(for: city.name) { [ weak self ] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherResponse):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.async { [ weak self ] in
                        self?.cities[index].temperature = weatherResponse.main.temp
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

}
