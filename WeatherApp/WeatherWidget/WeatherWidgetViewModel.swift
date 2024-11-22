import Foundation
import Combine
import Weather
import SwiftUI

class WeatherWidgetViewModel {

    @Published private(set) var currentCityName = ""
    @Published private(set) var locationEnabled: Bool = false
    @Published private(set) var weather: WeatherModel?

    private let getLocationUseCase: GetCurrentLocationUseCaseProtocol
    private let getWeatherUseCase: GetCurrentWeatherUseCaseProtocol
    private let getIdUseCase: GetCurrentLocationIdProtocol

    private var cancellables = Set<AnyCancellable>()

    init(
        getLocationUseCase: GetCurrentLocationUseCaseProtocol,
        getWeatherUseCase: GetCurrentWeatherUseCaseProtocol,
        getIdUseCase: GetCurrentLocationIdProtocol
    ) {
        self.getLocationUseCase = getLocationUseCase
        self.getWeatherUseCase = getWeatherUseCase
        self.getIdUseCase = getIdUseCase

        getLocationUseCase
            .isLocationEnabled()
            .receive(on: DispatchQueue.main)
            .assign(to: &$locationEnabled)

        getLocationUseCase
            .getCurrentCity()
            .catch { _ in Just("") }
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentCityName)
    }

    func fetchWeather() {
        getWeatherUseCase.getWeather(cityId: getIdUseCase.getId(), cityName: currentCityName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Error fetching weather with Combine: \(error)")
                }
            }, receiveValue: { weatherModel in
                DispatchQueue.main.async { [weak self] in
                    self?.weather = weatherModel
                }
            })
            .store(in: &cancellables)
    }

}

private extension WeatherModel {

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
