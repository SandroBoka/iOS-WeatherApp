import Foundation

protocol GetCitiesUseCaseProtocol {

    func getCities() -> [City]

}

class GetCitiesUseCase: GetCitiesUseCaseProtocol {

    private let locationRepository: LocationRepositoryProtocol
    private let weatherRepository: WeatherRepositoryProtocol

    init(locationRepository: LocationRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
    }

    func getCities() -> [City] {
        let cities = locationRepository.getLocationsWeather()

        for var city in cities {
            weatherRepository.fetchWeather(for: city.name) { [weak self] result in
                switch result {
                case .success(let weather):
                    self?.locationRepository.saveWeatherToRealm(weather: weather, cityName: city.name)
                    city.temperature = weather.temperature
                case .failure(let error):
                    print("Failed to fetch weather for \(city.name): \(error)")
                }
            }
        }

        return cities
    }

}
