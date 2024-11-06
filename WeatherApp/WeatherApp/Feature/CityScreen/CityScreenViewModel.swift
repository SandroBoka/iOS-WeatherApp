import SwiftUI
import RealmSwift

class CityScreenViewModel: ObservableObject {

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol

    @Published var city: String
    @Published var weather: WeatherModel?

    init(router: RouterProtocol, useCase: GetWeatherUseCaseProtocol, city: String) {
        self.router = router
        self.getWeatherUseCase = useCase
        self.city = city

        fetchWeather()
    }

    func fetchWeather() {
        getWeatherUseCase.getWeather(cityName: city) {[weak self] result in
            guard let self else { return }

            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async { [weak self] in
                    self?.weather = weatherModel
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
            }
        }
    }

    var weatherImage: WeatherImage {
        guard let weather = weather else { return .sunny }

        let isNightTime = isAfterSunsetOrBeforeSunrise(weather.sunrise, sunset: weather.sunset)

        if weather.statusId == 800 {
            return isNightTime ? .clearNight : .sunny
        } else if weather.statusId >= 200 && weather.statusId < 300 {
            return .thunderstorm
        } else if weather.statusId >= 300 && weather.statusId < 400 {
            return .rain
        } else if weather.statusId >= 500 && weather.statusId < 600 {
            return .rain
        } else if weather.statusId >= 600 && weather.statusId < 700 {
            return .snow
        } else if weather.statusId >= 700 && weather.statusId < 800 {
            return .atmosphere
        } else if weather.statusId >= 800 {
            return .cloudy
        } else {
            return isNightTime ? .clearNight : .sunny
        }
    }

    private func isAfterSunsetOrBeforeSunrise(_ sunrise: Int, sunset: Int) -> Bool {
        let currentTime = Int(Date().timeIntervalSince1970)
        return currentTime < sunrise || currentTime >= sunset
    }

    func formatTimeFromUnix(_ unixTime: Int, timeZoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime + timeZoneOffset))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter.string(from: date)
    }

    func goBack() {
        router.goBack()
    }

}

enum WeatherImage: String {

    case sunny
    case rain
    case cloudy
    case clearNight
    case atmosphere
    case snow
    case thunderstorm

    var image: Image {
        switch self {
        case .sunny:
            return Image(.sunny)
        case .rain:
            return Image(.rain)
        case .cloudy:
            return Image(.cloudy)
        case .clearNight:
            return Image(.clearNight)
        case .atmosphere:
            return Image(.atmosphere)
        case .snow:
            return Image(.snow)
        case .thunderstorm:
            return Image(.thunderstorm)
        }
    }

}
