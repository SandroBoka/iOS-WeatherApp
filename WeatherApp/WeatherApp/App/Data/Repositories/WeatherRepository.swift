import Foundation

protocol WeatherRepositoryProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class WeatherRepository: WeatherRepositoryProtocol {

<<<<<<< HEAD
    let weatherService: WeatherServiceProtocol
=======
    private let weatherService: WeatherServiceProtocol
>>>>>>> develop

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
<<<<<<< HEAD
                let weatherModel = self.mapToWeatherModel(response: currentWeatherResponse)
=======
                let weatherModel = WeatherModel(response: currentWeatherResponse)
>>>>>>> develop
                completion(.success(weatherModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

<<<<<<< HEAD
    private func mapToWeatherModel(response: CurrentWeatherResponse) -> WeatherModel {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        return WeatherModel(
            temp: response.main.temp,
=======
}

private extension WeatherModel {

    init(response: CurrentWeatherResponse) {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        self.init(
            temperature: response.main.temperature,
>>>>>>> develop
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
<<<<<<< HEAD
            degree: response.wind.degree,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset
        )
=======
            sunrise: response.system.sunrise,
            sunset: response.system.sunset)
>>>>>>> develop
    }

}
