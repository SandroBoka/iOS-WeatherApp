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
        Task {
            await fetchWeatherForAllCities()
        }
    }

    func fetchTemperature(for city: City) async {
        do {
            let weather = try await weatherService.fetchWeather(for: city.name)
            if let index = cities.firstIndex(where: { $0.id == city.id }) {
                DispatchQueue.main.async { [ weak self ] in
                    self?.cities[index].temperature = weather.main.temp
                }
            }
        } catch {
            print("Error fetching temperature for \(city.name): \(error)")
        }
    }

    func fetchWeatherForAllCities() async {
        for city in cities {
            await fetchTemperature(for: city)
        }
    }

    func showDetailsForCity(city: City) {
        router.showCityWeather(city: city)
    }

}
