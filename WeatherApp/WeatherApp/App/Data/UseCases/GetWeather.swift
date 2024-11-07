import Foundation

protocol GetWeatherUseCaseProtocol {

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void) {
        weatherRepository.fetchWeather(for: cityName, completion: completion)
    }

}
