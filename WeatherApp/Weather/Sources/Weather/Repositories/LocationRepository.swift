import Foundation
import Combine

public protocol LocationRepositoryProtocol {

    func getLocationsWeather() -> AnyPublisher<[City], Error>
    func removeCityWeather(city: City)
    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String)
    func getSuggestions(prefix: String) -> AnyPublisher<[SuggestedCity], Error>
    func getCityId(cityName: String) -> AnyPublisher<Int, Error>
    func getCurrentCity() -> AnyPublisher<String, Error>
    func isLocationEnabled() -> AnyPublisher<Bool, Never>
    func requestLocation()

}

public class LocationRepository: LocationRepositoryProtocol {

    private let defaultCities: [City] = [
        City(id: 3186886, name: "Zagreb"),
        City(id: 2968815, name: "Paris"),
        City(id: 5128638, name: "New York"),
        City(id: 1850147, name: "Tokyo"),
        City(id: 2643743, name: "London"),
        City(id: 5368361, name: "Los Angeles")]

    let realmService: RealmServiceProtocol
    let locationManager: LocationDataManager

    public init(realmService: RealmServiceProtocol, locationManager: LocationDataManager) {
        self.realmService = realmService
        self.locationManager = locationManager
    }

    public func getLocationsWeather() -> AnyPublisher<[City], Error> {
        realmService
            .getLocationWeathers()
            .map { [weak self] weatherModelObjects in
                if weatherModelObjects.isEmpty {
                    return self?.defaultCities ?? []
                } else {
                    return weatherModelObjects.map {
                        City(id: $0.cityId, name: $0.cityName, temperature: $0.temperature)
                    }
                }
            }
            .catch { error -> AnyPublisher<[City], Error> in
                print("Error fetching weather data: \(error)")

                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func removeCityWeather(city: City) {
        do {
            try realmService.removeWeather(cityId: city.id)
        } catch {
            print("Error deleting city: \(error)")
        }
    }

    public func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) {
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

    public func getSuggestions(prefix: String) -> AnyPublisher<[SuggestedCity], Error> {
        realmService
            .getCitiesByPrefix(prefix: prefix)
            .map { cityObjects in
                cityObjects.map { SuggestedCity(id: $0.id, cityName: $0.cityName) }
            }
            .catch { error -> AnyPublisher<[SuggestedCity], Error> in
                print("Error fetching suggestions from Realm: \(error)")

                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func getCityId(cityName: String) -> AnyPublisher<Int, Error> {
        realmService.getCityId(cityName: cityName)
    }

    public func getCurrentCity() -> AnyPublisher<String, Error> {
        locationManager
            .$currentCityName
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func isLocationEnabled() -> AnyPublisher<Bool, Never> {
        locationManager
            .authorizationEnabled
    }

    public func requestLocation() {
        locationManager.requestLocation()
    }

}
