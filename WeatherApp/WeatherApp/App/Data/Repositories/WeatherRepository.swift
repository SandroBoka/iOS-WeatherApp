import Foundation
import Combine

protocol WeatherRepositoryProtocol {

    func fetchWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError>

}

class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol
    let realmService: RealmServiceProtocol

    var cancellable: AnyCancellable?

    init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        realmService: RealmServiceProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.realmService = realmService
    }

    func fetchWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError> {
        locationService
            .fetchLocation(for: cityName)
            .flatMap { [weak self] locationResponse -> AnyPublisher<ExtraWeatherResponse, ClientError> in
                guard let self, let location = locationResponse.first else {
                    return Fail(error: ClientError.noData).eraseToAnyPublisher()
                }

                let latitude = location.latitude
                let longitude = location.longitude

                return self.weatherService.fetchExtraWeather(latitude: latitude, longitude: longitude)
            }
            .flatMap { [weak self] extraWeatherResponse -> AnyPublisher<WeatherModel, ClientError> in
                guard let self else {
                    return Fail(error: ClientError.noData).eraseToAnyPublisher()
                }

                return self.weatherService.fetchWeather(cityName: cityName)
                    .tryMap { [weak self] weatherResponse -> WeatherModel in
                        guard let self else { throw ClientError.noData }

                        var weatherModel = self.returnWeatherModel(
                            response: weatherResponse,
                            extraResponse: extraWeatherResponse
                        )

                        do {
                            try self.realmService.saveWeather(weather: weatherModel, cityId: cityId, cityName: cityName)
                        } catch {
                            print("Failed to save weather data to Realm: \(error)")
                        }

                        return weatherModel
                    }
                    .mapError { error in
                        return error as? ClientError ?? ClientError.unknown
                    }
                    .flatMap { [weak self] _ -> AnyPublisher<WeatherModel, ClientError> in
                        guard let self = self else {
                            return Fail(error: ClientError.noData).eraseToAnyPublisher()
                        }

                        return self.realmService.getWeather(cityId: cityId)
                            .map { WeatherModel(from: $0) }
                            .mapError { error in
                                return error as? ClientError ?? ClientError.noData
                            }
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .catch { [weak self] error -> AnyPublisher<WeatherModel, ClientError> in
                guard let self = self else {
                    return Fail(error: ClientError.unknown).eraseToAnyPublisher()
                }

                return self.realmService.getWeather(cityId: cityId)
                    .tryMap { weatherModelObject in
                        WeatherModel(from: weatherModelObject)
                    }
                    .mapError { error in
                        return error as? ClientError ?? ClientError.noData
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func returnWeatherModel(
        response: CurrentWeatherResponse,
        extraResponse: ExtraWeatherResponse
    ) -> WeatherModel {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        var hourly: [HourlyForecast] = extraResponse.hourly.prefix(24).map { hourlyWeather in
            HourlyForecast(
                temperature: hourlyWeather.temperature,
                uvIndex: hourlyWeather.uvIndex,
                percipation: hourlyWeather.percipation,
                hour: hourlyWeather.dateTime)
        }

        return WeatherModel(
            temperature: response.main.temperature,
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
            degrees: response.wind.degrees,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset,
            minTemperature: response.main.minimalTemperature,
            maxTemperature: response.main.maximalTemperature,
            statusId: response.weather[0].id,
            hourlyForecast: hourly)
    }

}
