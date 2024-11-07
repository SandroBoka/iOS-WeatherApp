import Foundation

protocol DataRepositoryProtocol {

    func storeCities(cities: [City])
    func getCities() -> [City]

}

class DataRepository: DataRepositoryProtocol {

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

    func storeCities(cities: [City]) {
        do {
            try realmService.saveCities(cities: mapToCityObject(cityModels: cities))
        } catch {
            print("Failed to save cities data to Realm: \(error)")
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
            storeCities(cities: cities)
        }

        return cities
    }

    private func mapToCityModel(cityObjects: [CityListObject]) -> [City] {
        return cityObjects.map { cityObject in
            City(name: cityObject.name, id: cityObject.id, temperature: cityObject.temperature)
        }
    }

    private func mapToCityObject(cityModels: [City]) -> [CityListObject] {
        return cityModels.map { cityModel in
            CityListObject(id: cityModel.id, name: cityModel.name, temperature: cityModel.temperature ?? 0.0)
        }
    }

}
