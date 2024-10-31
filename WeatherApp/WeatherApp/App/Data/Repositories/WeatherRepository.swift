import Foundation
import Combine

protocol WeatherRepositoryProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol

    var extraWeatherResponse: ExtraWeatherResponse?
    var cancellable: AnyCancellable?

    init(weatherService: WeatherServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func fetchWeather(
        for cityName: String,
        completion: @escaping (Result<WeatherModel, ClientError>) -> Void
    ) {
        fetchCityLocation(cityName: cityName)
        weatherService.fetchWeather(for: cityName) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let currentWeatherResponse):
                let weatherModel = self.mapToWeatherModel(response: currentWeatherResponse)
                completion(.success(weatherModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
                    hour: hourlyWeather.dateTime
                )
            }
        }

        return WeatherModel(
            temperature: response.main.temp,
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
            degrees: response.wind.deg,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset,
            minTemperature: response.main.tempMin,
            maxTemperature: response.main.tempMax,
            hourlyForecast: hourlyForecasts
        )
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
