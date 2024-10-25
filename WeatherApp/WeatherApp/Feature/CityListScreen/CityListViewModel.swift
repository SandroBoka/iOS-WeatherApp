import SwiftUI

class CityListViewModel: ObservableObject {

    @Published var cities: [City] = [] {
        didSet {
            saveCities()
        }
    }

    let appearance = UINavigationBarAppearance()

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let citiesKey = "savedCities"
    private let defaultCities: [City] = [
        City(name: "Zagreb"),
        City(name: "Paris"),
        City(name: "New York"),
        City(name: "Tokyo"),
        City(name: "London"),
        City(name: "Los Angeles")]

    init(router: RouterProtocol, useCase: GetWeatherUseCaseProtocol) {
        self.router = router
        self.getWeatherUseCase = useCase
        self.cities = loadCities()

        if cities.isEmpty {
            cities = self.defaultCities
        }

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

    func addCity(cityName: String) {
        let newCity = City(name: cityName)
        cities.append(newCity)
        fetchTemperature(for: newCity)
    }

    func removeCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }

    private func loadCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: citiesKey) else { return [] }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([City].self, from: data)
        } catch {
            print("Error loading cities: \(error)")
            return []
        }
    }

    private func saveCities() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(cities)
            UserDefaults.standard.set(data, forKey: citiesKey)
        } catch {
            print("Error saving cities: \(error)")
        }
    }

}
