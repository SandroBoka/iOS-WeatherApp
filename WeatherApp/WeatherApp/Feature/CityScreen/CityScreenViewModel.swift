import SwiftUI
import RealmSwift
import Combine

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol

    private var cancellable: AnyCancellable?

    @Published private(set) var city: City
    @Published private(set) var weather: WeatherModel?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter
    }()

    var weatherImage: ImageResource {
        guard let weather else { return .sunny }

        return weather.weatherImage
    }

    var sunriseTime: String {
        guard let weather else { return "" }

        return formatTimeFromUnix(unixTime: weather.sunrise, timeZoneOffset: 0)
    }

    var sunsetTime: String {
        guard let weather else { return "" }

        return formatTimeFromUnix(unixTime: weather.sunset, timeZoneOffset: 0)
    }

    var currentTempratureModel: TemperatureInfo.Model {
        TemperatureInfo.Model(title: String(localized: "current_string"), temperature: weather?.temperature ?? 0.0)
    }

    var feelsLikeTempratureModel: TemperatureInfo.Model {
        TemperatureInfo.Model(title: String(localized: "feels_like"), temperature: weather?.feelsLike ?? 0.0)
    }

    var sunriseModel: SunriseWidget.Model {
        SunriseWidget.Model(title: String(localized: "sunrise"), value: sunriseTime)
    }

    var sunsetModel: SunsetWidget.Model {
        SunsetWidget.Model(title: String(localized: "sunset"), value: sunsetTime)
    }

    var windModel: WindWidget.Model {
        WindWidget.Model(
            title: String(localized: "wind"), value: weather?.speed ?? 0.0, degree: Double(weather?.degrees ?? 0))
    }

    var humidityModel: HumidityWidget.Model {
        HumidityWidget.Model(title: String(localized: "humidity"), value: weather?.humidity ?? 0)
    }

    init(router: RouterProtocol, getWeatherUseCase: GetWeatherUseCaseProtocol, city: City) {
        self.router = router
        self.getWeatherUseCase = getWeatherUseCase
        self.city = city

        fetchWeather()
    }

    func fetchWeather() {
        cancellable = getWeatherUseCase.getWeather(cityId: city.id, cityName: city.name)
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
    }

    func goBack() {
        router.goBack()
    }

    private func formatTimeFromUnix(unixTime: Int, timeZoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime + timeZoneOffset))
        return dateFormatter.string(from: date)
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
