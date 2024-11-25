import Foundation
import Combine
import Weather
import SwiftUI
import CoreLocation

class WeatherWidgetViewModel: ObservableObject {

    @Published private(set) var currentCityName = "London"
    @Published private(set) var locationEnabled: Bool = false
    @Published private(set) var weather: WeatherModel?

    private let getLocationUseCase: GetCurrentLocationUseCaseProtocol
    private let getWeatherUseCase: GetCurrentWeatherUseCaseProtocol
    private let getIdUseCase: GetCurrentLocationIdUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    var currentTempratureModel: LargeTemperatureInfo.Model = LargeTemperatureInfo.Model(
        title: String(localized: "current_string"),
        temperature: 1.0)

    var feelsLikeTempratureModel: LargeTemperatureInfo.Model = LargeTemperatureInfo.Model(
        title: String(localized: "feels_like"),
        temperature: 2.0)

    init(
        getLocationUseCase: GetCurrentLocationUseCaseProtocol,
        getWeatherUseCase: GetCurrentWeatherUseCaseProtocol,
        getIdUseCase: GetCurrentLocationIdUseCaseProtocol
    ) {
        self.getLocationUseCase = getLocationUseCase
        self.getWeatherUseCase = getWeatherUseCase
        self.getIdUseCase = getIdUseCase

        getLocationUseCase.requestLocation()

        getLocationUseCase
            .isLocationEnabled()
            .receive(on: DispatchQueue.main)
            .assign(to: &$locationEnabled)

        getLocationUseCase
            .getCurrentCity()
            .catch { _ in Just("") }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentCity in
                guard let self else { return }

                self.currentCityName = currentCity
                if locationEnabled {
                    fetchWeather()
                }
            }
            .store(in: &cancellables)

        fetchWeather()
    }

    func fetchWeather() {
        getIdUseCase
            .getId(cityName: currentCityName)
            .flatMap { [weak self] id -> AnyPublisher<WeatherModel, Error> in
                guard let self else {
                    return Fail(
                        error: NSError(
                            domain: "WeatherWidgetViewModel",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Self is nil"]
                        )
                    ).eraseToAnyPublisher()
                }

                return self.getWeatherUseCase
                    .getWeather(cityId: id, cityName: self.currentCityName)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] weatherModel in
                self?.weather = weatherModel
                self?.currentTempratureModel.temperature = weatherModel.temperature
                self?.feelsLikeTempratureModel.temperature = weatherModel.feelsLike
            })
            .store(in: &cancellables)
    }

}

extension WeatherModel {

    var isNightTime: Bool {
        let currentTime = Int(Date().timeIntervalSince1970)
        return currentTime < sunrise || currentTime >= sunset
    }

    var weatherImage: ImageResource {
        if statusId == 800 {
            return isNightTime ? .clearNight : .sunny
        } else if statusId >= 200 && statusId < 300 {
            return .thunderstorm
        } else if statusId >= 300 && statusId < 400 {
            return .rain
        } else if statusId >= 500 && statusId < 600 {
            return .rain
        } else if statusId >= 600 && statusId < 700 {
            return .snow
        } else if statusId >= 700 && statusId < 800 {
            return .atmosphere
        } else if statusId >= 800 {
            return .cloudy
        } else {
            return isNightTime ? .clearNight : .sunny
        }
    }

}
