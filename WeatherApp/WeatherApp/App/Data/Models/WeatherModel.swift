import Foundation

struct WeatherModel {

    let temperature: Double
    let feelsLike: Double
    let description: String
    let humidity: Int
    let speed: Double
    let degrees: Int
    let sunrise: Int
    let sunset: Int
    let minTemperature: Double
    let maxTemperature: Double
    let statusId: Int
    let hourlyForecast: [HourlyForecast]

}

struct HourlyForecast {
    let id = UUID()
    let temperature: Double
    let uvIndex: Double
    let percipation: Double
    let hour: Int

    var formattedHour: String {
        let date = Date(timeIntervalSince1970: TimeInterval(hour))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        return formatter.string(from: date)
    }
}
