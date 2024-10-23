import Foundation

protocol GetWeatherUseCaseProtocol {
    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)
}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {

    private let weatherRepo: WeatherRepositoryProtocol

    init(weatherRepo: WeatherRepositoryProtocol) {
        self.weatherRepo = weatherRepo
    }

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void) {
        weatherRepo.fetchWeather(for: cityName, completion: completion)
    }

}
