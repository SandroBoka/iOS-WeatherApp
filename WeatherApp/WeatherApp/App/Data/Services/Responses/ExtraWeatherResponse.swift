import Foundation

struct ExtraWeatherResponse: Codable {

    let latitude: Double
    let longitude: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let minutely: [MinutelyWeather]
    let hourly: [HourlyWeather]

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case minutely
        case hourly
    }

}

struct CurrentWeather: Codable {

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

struct MinutelyWeather: Codable {

    let dateTime: Int
    let precipitation: Double

    enum CodingKeys: String, CodingKey {

        case dateTime = "dt"
        case precipitation
    }

}

struct HourlyWeather: Codable {

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
    let pop: Double

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
        case pop

    }

}

struct WeatherDescription: Codable {

    let id: Int
    let main: String
    let description: String
    let icon: String

}
