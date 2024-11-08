import Foundation

protocol LocationRepositoryProtocol {

    func getLocationsWeather() -> [City]
    func removeCityWeather(city: City)
    func saveWeatherToRealm(weather: WeatherModel, cityName: String)
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

    init(realmService: RealmServiceProtocol) {
        self.realmService = realmService
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

        return cities
    }

    func removeCityWeather(city: City) {
        do {
            try realmService.removeWeatherFromRealm(cityName: city.name)
        } catch {
            print("Error deleting city: \(error)")
        }
    }

    func saveWeatherToRealm(weather: WeatherModel, cityName: String) {
        do {
            try realmService.saveWeatherToRealm(
                weather: weather,
                cityName: cityName
            )
        } catch {
            print("Failed to save weather to Realm: \(error)")
        }
    }

    func getSuggestions(prefix: String) -> [SuggestedCity] {
        realmService.getCitiesByPrefix(prefix: prefix).map { SuggestedCity(id: $0.id, cityName: $0.cityName) }
    }

}
