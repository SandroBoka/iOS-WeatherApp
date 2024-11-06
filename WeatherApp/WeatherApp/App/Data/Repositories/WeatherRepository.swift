import Foundation

protocol WeatherRepositoryProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class WeatherRepository: WeatherRepositoryProtocol {

    private let weatherService: WeatherServiceProtocol

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
                let weatherModel = WeatherModel(response: currentWeatherResponse)
                completion(.success(weatherModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private extension WeatherModel {

    init(response: CurrentWeatherResponse) {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        self.init(
            temperature: response.main.temperature,
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
            degree: response.wind.degree,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset)
    }

}
