import Foundation

public struct ExtraWeatherResponse: Decodable {

    let latitude: Double
    let longitude: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case hourly
    }

}

struct CurrentWeather: Decodable {

    let dateTime: Int
    let sunrise: Int
    let sunset: Int
    let temperature: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvIndex: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDegree: Int
    let weather: [WeatherDescription]

    enum CodingKeys: String, CodingKey {

        case dateTime = "dt"
        case sunrise
        case sunset
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvIndex = "uvi"
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case weather

    }

}

struct HourlyWeather: Decodable {

    let dateTime: Int
    let temperature: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvIndex: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDegree: Int
    let windGust: Double?
    let weather: [WeatherDescription]
    let percipation: Double

    enum CodingKeys: String, CodingKey {

        case dateTime = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvIndex = "uvi"
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case windGust = "wind_gust"
        case weather
        case percipation = "pop"

    }

}

struct WeatherDescription: Decodable {

    let id: Int
    let main: String
    let description: String
    let icon: String

}
