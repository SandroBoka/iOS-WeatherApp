import Foundation
import Combine

protocol WeatherRepositoryProtocol {

    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherModel, ClientError>) -> Void)

}

class WeatherRepository: WeatherRepositoryProtocol {

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol

    var cancellable: AnyCancellable?

    init(weatherService: WeatherServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
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

        fetchCityLocation(cityName: cityName)
    }

    func fetchExtraWeather(latitude: Double, longitude: Double) {
        cancellable = weatherService.fetchExtraWeather(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error getting extra weather info: \(error)")
                }
            }, receiveValue: { extraWeatherResponse in
                print(extraWeatherResponse)
            })
    }

    private func mapToWeatherModel(response: CurrentWeatherResponse) -> WeatherModel {
        let weatherDescription = response.weather.first?.description ?? "Not Avaliable"

        return WeatherModel(
            temp: response.main.temp,
            feelsLike: response.main.feelsLike,
            description: weatherDescription,
            humidity: response.main.humidity,
            speed: response.wind.speed,
            deg: response.wind.deg,
            sunrise: response.system.sunrise,
            sunset: response.system.sunset
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
                self?.fetchExtraWeather(latitude: latitude, longitude: latitude)
            })
    }

}
