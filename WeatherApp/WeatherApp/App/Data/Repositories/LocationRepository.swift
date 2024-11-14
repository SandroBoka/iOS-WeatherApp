import Foundation
import Combine

protocol LocationRepositoryProtocol {

    func getLocationsWeather() -> AnyPublisher<[City], Error>
    func removeCityWeather(city: City)
    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String)
    func getSuggestions(prefix: String) -> [SuggestedCity]
    func getCityId(cityName: String) -> Int

}

class LocationRepository: LocationRepositoryProtocol {

    private let defaultCities: [City] = [
        City(id: 3186886, name: "Zagreb"),
        City(id: 2968815, name: "Paris"),
        City(id: 5128638, name: "New York"),
        City(id: 1850147, name: "Tokyo"),
        City(id: 2643743, name: "London"),
        City(id: 5368361, name: "Los Angeles")]

    let realmService: RealmServiceProtocol

    init(realmService: RealmServiceProtocol) {
        self.realmService = realmService
    }

    func getLocationsWeather() -> AnyPublisher<[City], Error> {
        realmService
            .getLocationWeathers()
            .map { weatherModelObjects in
                weatherModelObjects.map { City(id: $0.cityId, name: $0.cityName, temperature: $0.temperature) }
            }
            .catch { error -> AnyPublisher<[City], Error> in
                print("Error fetching weather data: \(error)")

                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func removeCityWeather(city: City) {
        do {
            try realmService.removeWeather(cityId: city.id)
        } catch {
            print("Error deleting city: \(error)")
        }
    }

    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) {
        do {
            try realmService.saveWeather(
                weather: weather,
                cityId: cityId,
                cityName: cityName
            )
        } catch {
            print("Failed to save weather to Realm: \(error)")
        }
    }

    func getSuggestions(prefix: String) -> [SuggestedCity] {
        realmService.getCitiesByPrefix(prefix: prefix).map { SuggestedCity(id: $0.id, cityName: $0.cityName) }
    }

    func getCityId(cityName: String) -> Int {
        realmService.getCityId(cityName: cityName)
    }

}
