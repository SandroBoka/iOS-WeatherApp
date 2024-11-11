import Foundation
import Combine

protocol GetWeatherUseCaseProtocol {

    func getWeather(cityName: String) -> AnyPublisher<WeatherModel, ClientError>

}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    func getWeather(cityName: String) -> AnyPublisher<WeatherModel, ClientError> {
        weatherRepository.fetchWeather(cityName: cityName)
    }

}
