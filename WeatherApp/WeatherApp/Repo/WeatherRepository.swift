import Foundation

protocol WeatherRepositoryProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    func fetchWeather(
        for cityName: String,
        completion: @escaping (Result<WeatherModel, ClientError>) -> Void
    ) {
        weatherService.fetchWeather(for: cityName) { result in
            switch result {
            case .success(let currentWeatherResponse):
                let weatherModel = self.mapToWeatherModel(response: currentWeatherResponse)
                completion(.success(weatherModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func mapToWeatherModel(response: CurrentWeatherResponse) -> WeatherModel {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        return WeatherModel(
            temp: response.main.temp,
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset
        )
    }

}

