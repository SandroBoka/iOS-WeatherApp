import Foundation
import Combine
import Weather

protocol GetWeatherUseCaseProtocol {

    func getWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError>

}

class GetWeatherUseCase: GetWeatherUseCaseProtocol {

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }

    func getWeather(cityId: Int, cityName: String) -> AnyPublisher<WeatherModel, ClientError> {
        weatherRepository.fetchWeather(cityId: cityId, cityName: cityName)
    }

}
