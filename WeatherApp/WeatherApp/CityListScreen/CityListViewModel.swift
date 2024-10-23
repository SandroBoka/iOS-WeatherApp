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
    private let getWeatherUseCase: GetWeatherUseCaseProtocol

    init(router: RouterProtocol, useCase: GetWeatherUseCaseProtocol) {
        self.router = router
        self.getWeatherUseCase = useCase

        fetchWeatherForAllCities()
    }

    func fetchTemperature(for city: City) {
        getWeatherUseCase.getWeather(cityName: city.name) { [ weak self ] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherModel):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.sync { [ weak self ] in
                        self?.cities[index].temperature = weatherModel.temp
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
