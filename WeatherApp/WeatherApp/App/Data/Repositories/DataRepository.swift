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

    let dataService: DataServiceProtocol

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }

    func storeCities(cities: [City]) {
        dataService.storeCities(cities: cities)
    }

    func getCities() -> [City] {
        var cities = dataService.getCities()

        if cities.isEmpty {
            cities = defaultCities
        }

        return cities
    }

}
