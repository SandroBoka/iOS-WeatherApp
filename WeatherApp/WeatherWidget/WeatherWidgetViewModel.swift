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

//        getLocationUseCase
//            .getCurrentCity()
//            .catch { _ in Just("") }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] currentCity in
//                guard let self else { return }
//
//                print(locationEnabled)
//                print(currentCity)
//                self.currentCityName = currentCity
//                if locationEnabled {
//                    fetchWeather()
//                }
//            }
//            .store(in: &cancellables)

//        fetchWeather()
    }

//    func fetchWeather() {
//        getWeatherUseCase.getWeather(cityId: 4119617, cityName: "London")
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    return
//                case .failure(let error):
//                    print("Error fetching weather with Combine: \(error)")
//                }
//            }, receiveValue: { weatherModel in
//                DispatchQueue.main.async { [weak self] in
//                    self?.weather = weatherModel
//                }
//            })
//            .store(in: &cancellables)
//    }

    func fetchWeather() -> AnyPublisher<WeatherModel, ClientError> {
        getWeatherUseCase.getWeather(cityId: 4119617, cityName: "London")
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
