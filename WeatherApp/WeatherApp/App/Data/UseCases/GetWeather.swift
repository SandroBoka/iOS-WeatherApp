import Foundation

protocol GetWeatherUseCaseProtocol {
<<<<<<< HEAD
    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)
=======

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

>>>>>>> develop
}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {

<<<<<<< HEAD
    private let weatherRepo: WeatherRepositoryProtocol

    init(weatherRepo: WeatherRepositoryProtocol) {
        self.weatherRepo = weatherRepo
    }

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void) {
        weatherRepo.fetchWeather(for: cityName, completion: completion)
=======
    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    func getWeather(cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void) {
        weatherRepository.fetchWeather(for: cityName, completion: completion)
>>>>>>> develop
    }

}
