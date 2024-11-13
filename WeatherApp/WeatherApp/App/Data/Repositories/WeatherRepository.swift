import Foundation
import Combine

protocol WeatherRepositoryProtocol {

    func fetchWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError>

}

class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol
    let realmService: RealmServiceProtocol

    var extraWeatherResponse: ExtraWeatherResponse?
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
            .flatMap { [weak self] locationResponse in
                guard let self else { return [] }

                let latitude = locationResponse[0].latitude
                let longitude = locationResponse[0].longitude

                return self.weatherService.fetchExtraWeather(latitude: latitude, longitude: longitude)
            }
            .flatMap { extraWeatherResponse in
                self.weatherService
                    .fetchWeather(cityName: cityName)
                    .tryMap { [weak self] currentWeatherResponse -> WeatherModel in
                        guard let self else { throw ClientError.noData }

                        var weatherModel = self.mapToWeatherModel(response: currentWeatherResponse)

                        do {
                            try realmService.saveWeather(weather: weatherModel, cityId: cityId, cityName: cityName)
                        } catch {
                            print("Failed to save weather data to Realm: \(error)")
                        }

                        return weatherModel
                    }
                    .mapError { error -> ClientError in
                        error as? ClientError ?? .unknown
                    }
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] _ -> AnyPublisher<WeatherModel, ClientError> in
                guard let self = self else {
                    return Fail(error: .noData).eraseToAnyPublisher()
                }
                return self.realmService.getWeather(cityId: cityId)
                    .map { cachedWeather in
                        WeatherModel(from: cachedWeather)
                    }
                    .mapError { error in
                        error as? ClientError ?? .unknown
                    }

            }
            .eraseToAnyPublisher()
    }

    func fetchExtraWeather(latitude: Double, longitude: Double) {
        cancellable = weatherService.fetchExtraWeather(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error getting extra weather info: \(error)")
                }
            }, receiveValue: { [weak self] extraWeatherResponse in
                self?.extraWeatherResponse = extraWeatherResponse
            })
    }

    private func mapToWeatherModel(response: CurrentWeatherResponse) -> WeatherModel {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        var hourlyForecasts: [HourlyForecast] = []

        if let extraWeatherResponse = self.extraWeatherResponse {
            hourlyForecasts = extraWeatherResponse.hourly.prefix(24).map { hourlyWeather in
                HourlyForecast(
                    temperature: hourlyWeather.temperature,
                    uvIndex: hourlyWeather.uvIndex,
                    percipation: hourlyWeather.percipation,
                    hour: hourlyWeather.dateTime)
            }
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
            hourlyForecast: hourlyForecasts)
    }

    private func fetchCityLocation(cityName: String) {
        cancellable = locationService.fetchLocation(for: cityName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error fetching location: \(error)")
                }
            }, receiveValue: { [weak self] locationResponse in
                let latitude = locationResponse[0].latitude
                let longitude = locationResponse[0].longitude
                self?.fetchExtraWeather(latitude: latitude, longitude: longitude)
            })
    }

}
