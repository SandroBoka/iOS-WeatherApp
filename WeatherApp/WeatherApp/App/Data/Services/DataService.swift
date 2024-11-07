import Foundation

protocol DataServiceProtocol {

    func storeCities(cities: [City])
    func getCities() -> [City]

}

class DataService: DataServiceProtocol {

    private let citiesKey = "savedCities"

    func storeCities(cities: [City]) {
        do {
            let data = try JSONEncoder().encode(cities)
            UserDefaults.standard.set(data, forKey: citiesKey)
        } catch {
            print("Error saving cities: \(error)")
        }
    }

    func getCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: citiesKey) else { return [] }

        do {
            return try JSONDecoder().decode([City].self, from: data)
        } catch {
            print("Error loading cities: \(error)")
            return []
        }
    }

}
