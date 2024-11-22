import Foundation
import Combine

public protocol WeatherRepositoryProtocol {

    func fetchWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError>

}

public class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol
    let realmService: RealmServiceProtocol

    public init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        realmService: RealmServiceProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.realmService = realmService
    }

    public func fetchWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError> {
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

                        let weatherModel = WeatherModel(response: weatherResponse, extraResponse: extraWeatherResponse)

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

                        return self.getWeatherFromStorage(cityId: cityId)
                    }
                    .eraseToAnyPublisher()
            }
            .catch { [weak self] _ -> AnyPublisher<WeatherModel, ClientError> in
                guard let self else {
                    return Fail(error: ClientError.unknown).eraseToAnyPublisher()
                }

                return self.getWeatherFromStorage(cityId: cityId)
            }
            .eraseToAnyPublisher()
    }

    private func getWeatherFromStorage(cityId: Int) -> AnyPublisher<WeatherModel, ClientError> {
        return realmService.getWeather(cityId: cityId)
            .tryMap { weatherModelObject in
                WeatherModel(from: weatherModelObject)
            }
            .mapError { error in
                return error as? ClientError ?? ClientError.noData
            }
            .eraseToAnyPublisher()
    }

}
