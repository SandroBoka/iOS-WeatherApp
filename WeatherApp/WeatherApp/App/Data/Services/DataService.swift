import Foundation

protocol DataServiceProtocol {

    func storeCities(cities: [City])
    func getCities() -> [City]

}

class DataService: DataServiceProtocol {

    private let citiesKey = "savedCities"

    func storeCities(cities: [City]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(cities)
            UserDefaults.standard.set(data, forKey: citiesKey)
        } catch {
            print("Error saving cities: \(error)")
        }
    }

    func getCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: citiesKey) else { return [] }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([City].self, from: data)
        } catch {
            print("Error loading cities: \(error)")
            return []
        }
    }

}

