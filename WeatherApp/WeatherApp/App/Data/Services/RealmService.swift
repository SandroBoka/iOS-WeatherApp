import RealmSwift
import Combine
import Foundation

protocol RealmServiceProtocol {

    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) throws
    func getWeather(cityId: Int) -> AnyPublisher<WeatherModelObject, Error>
    func removeWeather(cityId: Int) throws
    func getLocationWeathers() -> AnyPublisher<[WeatherModelObject], Error>
    func getCitiesFromJson() -> Bool
    func getCitiesByPrefix(prefix: String) -> AnyPublisher<[CityObject], Error>
    func getCityId(cityName: String) -> AnyPublisher<Int, Error>

}

class RealmService: RealmServiceProtocol {

    func saveWeather(weather: WeatherModel, cityId: Int, cityName: String) throws {
        let realm = try Realm()

        let weatherModelRealm = WeatherModelObject(weather: weather, cityId: cityId, cityName: cityName)

        try realm.write {
            realm.add(weatherModelRealm, update: .modified)
        }
    }

    func getWeather(cityId: Int) -> AnyPublisher<WeatherModelObject, Error> {
       Future<WeatherModelObject, Error> { promise in
            do {
                let realm = try Realm()
                guard let savedWeather = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityId) else {
                    throw CityScreenError.weatherNotFoundInRealm
                }

                promise(.success(savedWeather))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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

    func getLocationWeathers() -> AnyPublisher<[WeatherModelObject], Error> {
        Future <[WeatherModelObject], Error> { promise in
            do {
                let realm = try Realm()
                let locationWeathers = realm.objects(WeatherModelObject.self)

                promise(.success(Array(locationWeathers)))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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

    func getCitiesByPrefix(prefix: String) -> AnyPublisher<[CityObject], Error> {
        Future <[CityObject], Error> { promise in
            do {
                let realm = try Realm()
                let predicate = NSPredicate(format: "cityName BEGINSWITH[c] %@", prefix)
                let cities = realm.objects(CityObject.self).filter(predicate).sorted(byKeyPath: "cityName").prefix(5)

                promise(.success(Array(cities)))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func getCityId(cityName: String) -> AnyPublisher<Int, Error> {
        Future <Int, Error> { promise in
            do {
                let realm = try Realm()
                let city = realm.objects(CityObject.self)
                    .filter("cityName ==[c] %@", cityName)
                    .first

                promise(.success(city?.id ?? 11))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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
