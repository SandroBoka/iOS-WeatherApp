import Foundation
import Combine
import Weather

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
        locationRepository.getLocationsWeather()
            .flatMap { cities in
                Publishers.MergeMany(
                    cities.map { [weak self] city in
                        guard let self else {
                            return Just(city).eraseToAnyPublisher()
                        }

                        return self.weatherRepository.fetchWeather(cityId: city.id, cityName: city.name)
                            .map { weatherModel -> City in
                                var updatedCity = city
                                updatedCity.temperature = weatherModel.temperature
                                return updatedCity
                            }
                            .catch { _ in Just(city) }
                            .eraseToAnyPublisher()
                    })
                .collect()
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }

}
