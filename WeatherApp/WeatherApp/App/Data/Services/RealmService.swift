import RealmSwift
import Foundation

protocol RealmServiceProtocol {

    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) throws
    func getWeather(cityId: Int) throws -> WeatherModelObject
    func removeWeather(cityId: Int) throws
    func getLocationWeathers() throws -> [WeatherModelObject]
    func getCitiesFromJson() -> Bool
    func getCitiesByPrefix(prefix: String) -> [CityObject]
    func getCityId(cityName: String) -> Int

}

class RealmService: RealmServiceProtocol {

    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) throws {
        let realm = try Realm()

        let weatherModelRealm = WeatherModelObject(weather: weather, cityId: cityId, cityName: cityName)

        try realm.write {
            realm.add(weatherModelRealm, update: .modified)
        }
    }

    func getWeather(cityId: Int) throws -> WeatherModelObject {
        let realm = try Realm()

        guard let savedWeather = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityId) else {
            throw CityScreenError.weatherNotFoundInRealm
        }

        return savedWeather
    }

    func removeWeather(cityId: Int) throws {
        let realm = try Realm()

        if let weatherToDelete = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityId) {
            try realm.write {
                realm.delete(weatherToDelete)
            }
        } else {
            throw CityScreenError.weatherNotFoundInRealm
        }
    }

    func getLocationWeathers() throws -> [WeatherModelObject] {
        let realm = try Realm()
        return Array(realm.objects(WeatherModelObject.self))
    }

    func getCitiesFromJson() -> Bool {
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json") else {
            print("JSON file not found")
            return false
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let cities = try JSONDecoder().decode([CityJSON].self, from: data)
            let realmCities = cities.map { CityObject(id: $0.id, cityName: $0.name) }

            let realm = try Realm()

            try realm.write {
                realm.add(realmCities)
            }

            print("city_list.json is now saved in the database")
            return true
        } catch {
            print("Error reading cities from json file: \(error)")
            return false
        }
    }

    func getCitiesByPrefix(prefix: String) -> [CityObject] {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "cityName BEGINSWITH[c] %@", prefix)
            let cities = realm.objects(CityObject.self).filter(predicate).sorted(byKeyPath: "cityName").prefix(5)
            return Array(cities)
        } catch {
            return []
        }
    }

    func getCityId(cityName: String) -> Int {
        do {
            let realm = try Realm()
            guard
                let city = realm.objects(CityObject.self)
                    .filter("cityName ==[c] %@", cityName)
                    .first
            else { return 0 }

            return city.id
        } catch {
            print("Error accessing Realm: \(error)")
            return 0
        }
    }

}

extension RealmService {

    struct CityJSON: Decodable {

        let id: Int
        let name: String

    }

}

enum CityScreenError: Error {

    case realmInitializationFailed
    case weatherNotFoundInRealm

}
