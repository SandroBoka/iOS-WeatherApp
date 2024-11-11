import Foundation
import Combine

protocol GetCitiesUseCaseProtocol {

    func getCities() -> AnyPublisher<[City], Never>

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol
    private let weatherRepository: WeatherRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
    }

    func getCities() -> AnyPublisher<[City], Never> {
        let cities = locationRepository.getLocationsWeather()

        let weatherFetches = cities.map { city in
            weatherRepository.fetchWeather(cityName: city.name)
                .map { weatherModel in
                    var updatedCity = city
                    updatedCity.temperature = weatherModel.temperature
                    return updatedCity
                }
                .catch { _ in Just(city) }
        }

        return Publishers.MergeMany(weatherFetches)
            .collect()
            .eraseToAnyPublisher()
    }

}
