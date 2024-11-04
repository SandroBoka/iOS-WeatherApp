import SwiftUI
import RealmSwift

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol

    @Published var city: String
    @Published var weather: WeatherModel?

    init(router: RouterProtocol, useCase: GetWeatherUseCaseProtocol, city: String) {
        self.router = router
        self.getWeatherUseCase = useCase
        self.city = city

        fetchWeather()
    }

    func fetchWeather() {

        getWeatherUseCase.getWeather(cityName: city) {[weak self] result in
            guard let self else { return }

            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async { [weak self] in
                    self?.weather = weatherModel
                }
                try? saveWeatherToRealm(weather: weatherModel, cityName: self.city)
            case .failure(let error):
                print("Error fetching weather: \(error)")
                try? loadWeatherFromRealm(cityName: self.city)
            }
        }
    }

    func formatTimeFromUnix(_ unixTime: Int, timeZoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime + timeZoneOffset))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter.string(from: date)
    }

    func goBack() {
        router.goBack()
    }
}

enum CityScreenError: Error {

    case realmInitializationFailed
    case weatherNotFoundInRealm

}

private extension CityScreenViewModel {

    private func saveWeatherToRealm(weather: WeatherModel, cityName: String) throws {

        guard let realm = try? Realm() else { throw CityScreenError.realmInitializationFailed }

        let weatherModelRealm = WeatherModelObject()
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

    private func loadWeatherFromRealm(cityName: String) throws {
        guard let realm = try? Realm() else { throw CityScreenError.realmInitializationFailed }

        guard let savedWeather = realm.object(ofType: WeatherModelObject.self, forPrimaryKey: cityName) else {
            throw CityScreenError.weatherNotFoundInRealm
        }

        let hourlyForecasts = Array(savedWeather.hourlyForecasts.map {
            HourlyForecast(temperature: $0.temperature, uvIndex: $0.uvIndex, percipation: $0.percipation, hour: $0.hour)
        })

        let weatherData = WeatherModel(
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
            hourlyForecast: hourlyForecasts)

        DispatchQueue.main.async { [weak self] in
            self?.weather = weatherData
        }
    }

}
