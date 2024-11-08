import Foundation

protocol LocationRepositoryProtocol {

    func storeCity(city: City)
    func getCities() -> [City]
    func removeCity(city: City)
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

    func storeCity(city: City) {
        do {
            try realmService.saveCity(
                city: CityListObject(
                    id: city.id,
                    name: city.name,
                    temperature: city.temperature ?? 0))
        } catch {
            print("Failed to save city data to Realm: \(error)")
        }
    }

    func getCities() -> [City] {
        var cities: [City] = []
        do {
            cities = try mapToCityModel(cityObjects: realmService.loadCities())
        } catch {
            print("Failed to load cities from to Realm: \(error)")
        }

        if cities.isEmpty {
            cities = defaultCities
            cities.forEach { city in
                storeCity(city: city)
            }
        }

        return cities
    }

    func removeCity(city: City) {
        do {
            try realmService.removeCity(
                city: CityListObject(
                    id: city.id,
                    name: city.name,
                    temperature: city.temperature ?? 0))
        } catch {
            print("Error deleting city: \(error)")
        }
    }

    func getSuggestions(prefix: String) -> [SuggestedCity] {
        realmService.getCitiesByPrefix(prefix: prefix).map { SuggestedCity(id: $0.id, cityName: $0.cityName) }
    }

}

extension LocationRepository {

    private func mapToCityModel(cityObjects: [CityListObject]) -> [City] {
        cityObjects.map { cityObject in
            City(name: cityObject.name, id: cityObject.id, temperature: cityObject.temperature)
        }
    }

    private func mapToCityObject(cityModels: [City]) -> [CityListObject] {
        cityModels.map { cityModel in
            CityListObject(id: cityModel.id, name: cityModel.name, temperature: cityModel.temperature ?? 0.0)
        }
    }

}
