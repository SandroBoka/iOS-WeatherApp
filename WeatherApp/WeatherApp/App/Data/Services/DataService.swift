import Foundation

protocol DataServiceProtocol {

    func storeCities(cities: [City])
    func getCities() -> [City]

}

class DataService: DataServiceProtocol {

    private let citiesKey = "savedCities"

    func storeCities(cities: [City]) {
<<<<<<< HEAD
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(cities)
=======
        do {
            let data = try JSONEncoder().encode(cities)
>>>>>>> develop
            UserDefaults.standard.set(data, forKey: citiesKey)
        } catch {
            print("Error saving cities: \(error)")
        }
    }

    func getCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: citiesKey) else { return [] }

<<<<<<< HEAD
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([City].self, from: data)
=======
        do {
            return try JSONDecoder().decode([City].self, from: data)
>>>>>>> develop
        } catch {
            print("Error loading cities: \(error)")
            return []
        }
    }

}
