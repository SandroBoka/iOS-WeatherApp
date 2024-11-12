import RealmSwift
import Foundation

protocol RealmServiceProtocol {

    func saveWeatherToRealm(weather: WeatherModel, cityId: Int, cityName: String) throws
    func loadWeatherFromRealm(cityId: Int) throws -> WeatherModel
    func removeWeatherFromRealm(cityId: Int) throws
    func loadLocationWeathers() throws -> [WeatherModelObject]
    func loadCitiesFromJson() -> Bool
    func getCitiesByPrefix(prefix: String) -> [CityObject]
    func getCityId(cityName: String) -> Int

}

class RealmService: RealmServiceProtocol {

    func saveWeatherToRealm(weather: WeatherModel, cityId: Int, cityName: String) throws {
        let realm = try Realm()

        let weatherModelRealm = WeatherModelObject()
        weatherModelRealm.cityId = cityId
        weatherModelRealm.cityName = cityName
        weatherModelRealm.temperature = weather.temperature
        weatherModelRealm.feelsLike = weather.feelsLike
        weatherModelRealm.weatherDescription = weather.description
        weatherModelRealm.humidity = weather.humidity
        weatherModelRealm.speed = weather.speed
        weatherModelRealm.degrees = weather.degrees
        weatherModelRealm.sunrise = weather.sunrise
        weatherModelRealm.sunset = weather.sunset
        weatherModelRealm.minTemperature = weather.minTemperature
        weatherModelRealm.maxTemperature = weather.maxTemperature

        weatherModelRealm.hourlyForecasts.append(objectsIn: weather.hourlyForecast.map {
            let hourlyForecastObject = HourlyForecastObject()
            hourlyForecastObject.temperature = $0.temperature
            hourlyForecastObject.uvIndex = $0.uvIndex
            hourlyForecastObject.percipation = $0.percipation
            hourlyForecastObject.hour = $0.hour
            return hourlyForecastObject
        })

        try realm.write {
            realm.add(weatherModelRealm, update: .modified)
        }
    }

    func loadWeatherFromRealm(cityId: Int) throws -> WeatherModel {
        let realm = try Realm()

        guard let savedWeather = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityId) else {
            throw CityScreenError.weatherNotFoundInRealm
        }

        let hourlyForecasts = Array(savedWeather.hourlyForecasts.map {
            HourlyForecast(temperature: $0.temperature, uvIndex: $0.uvIndex, percipation: $0.percipation, hour: $0.hour)
        })

        return WeatherModel(
            temperature: savedWeather.temperature,
            feelsLike: savedWeather.feelsLike,
            description: savedWeather.weatherDescription,
            humidity: savedWeather.humidity,
            speed: savedWeather.speed,
            degrees: savedWeather.degrees,
            sunrise: savedWeather.sunrise,
            sunset: savedWeather.sunset,
            minTemperature: savedWeather.minTemperature,
            maxTemperature: savedWeather.maxTemperature,
            statusId: savedWeather.statusId,
            hourlyForecast: hourlyForecasts)
    }

    func removeWeatherFromRealm(cityId: Int) throws {
        let realm = try Realm()

        if let weatherToDelete = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityId) {
            try realm.write {
                realm.delete(weatherToDelete)
            }
        } else {
            throw CityScreenError.weatherNotFoundInRealm
        }
    }

    func loadLocationWeathers() throws -> [WeatherModelObject] {
        let realm = try Realm()
        return Array(realm.objects(WeatherModelObject.self))
    }

    func loadCitiesFromJson() -> Bool {
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
            if let city = realm.objects(CityObject.self)
                .filter("cityName ==[c] %@", cityName)
                .first {
                return city.id
            } else {
                return 0
            }
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
