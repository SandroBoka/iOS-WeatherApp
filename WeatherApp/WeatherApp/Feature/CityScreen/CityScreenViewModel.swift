import SwiftUI

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
        getWeatherUseCase.getWeather(cityName: city) { result in
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

    func formatTimeFromUnix(_ unixTime: Int, timeZoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime + timeZoneOffset))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter.string(from: date)
    }

}
