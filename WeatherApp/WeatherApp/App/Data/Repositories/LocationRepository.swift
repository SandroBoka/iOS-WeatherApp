import Foundation

protocol LocationRepositoryProtocol {

    func getLocationsWeather() -> [City]
    func removeCityWeather(city: City)
    func getSuggestions(prefix: String) -> [SuggestedCity]

}

class LocationRepository: LocationRepositoryProtocol {

    private let defaultCities: [City] = [
        City(name: "Zagreb"),
        City(name: "Paris"),
        City(name: "New York"),
        City(name: "Tokyo"),
        City(name: "London"),
        City(name: "Los Angeles")]

    let realmService: RealmServiceProtocol
    let weatherRepository: WeatherRepositoryProtocol

    init(realmService: RealmServiceProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.realmService = realmService
        self.weatherRepository = weatherRepository
    }

    func getLocationsWeather() -> [City] {
        var cities: [City] = []
        do {
            cities = try realmService.loadLocationWeathers().map {
                City(
                    name: $0.cityName,
                    temperature: $0.temperature)
            }
        } catch {
            print("Failed to load cities from to Realm: \(error)")
        }

        if cities.isEmpty {
            cities = defaultCities
        }

        for var city in cities {
            weatherRepository.fetchWeather(for: city.name) { [weak self] result in
                switch result {
                case .success(let weather):
                    do {
                        try self?.realmService.saveWeatherToRealm(weather: weather, cityName: city.name)
                        city.temperature = weather.temperature
                    } catch {
                        print("Failed to save weather to Realm: \(error)")
                    }
                case .failure(let error):
                    print("Failed to fetch weather for \(city.name): \(error)")
                }
            }
        }

        return cities
    }

    func removeCityWeather(city: City) {
        do {
            try realmService.removeWeatherFromRealm(cityName: city.name)
        } catch {
            print("Error deleting city: \(error)")
        }
    }

    func getSuggestions(prefix: String) -> [SuggestedCity] {
        realmService.getCitiesByPrefix(prefix: prefix).map { SuggestedCity(id: $0.id, cityName: $0.cityName) }
    }

}
