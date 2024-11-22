import Foundation

public struct WeatherModel {

    public let temperature: Double
    public let feelsLike: Double
    public let description: String
    public let humidity: Int
    public let speed: Double
    public let degrees: Int
    public let sunrise: Int
    public let sunset: Int
    public let minTemperature: Double
    public let maxTemperature: Double
    public let statusId: Int
    public let hourlyForecast: [HourlyForecast]

}

public struct HourlyForecast {

    public init(temperature: Double, uvIndex: Double, percipation: Double, hour: Int) {
        self.temperature = temperature
        self.uvIndex = uvIndex
        self.percipation = percipation
        self.hour = hour
    }

    public let id = UUID()
    public let temperature: Double
    public let uvIndex: Double
    public let percipation: Double
    public let hour: Int

}

extension WeatherModel {

    public init(dummyData: Bool = false) {
        self.temperature = 20.5
        self.feelsLike = 19.8
        self.description = "Partly Cloudy"
        self.humidity = 60
        self.speed = 5.5
        self.degrees = 180
        self.sunrise = Int(Date().addingTimeInterval(-3600).timeIntervalSince1970)
        self.sunset = Int(Date().addingTimeInterval(3600 * 16).timeIntervalSince1970)
        self.minTemperature = 18.0
        self.maxTemperature = 22.0
        self.statusId = 801
        self.hourlyForecast = [
            HourlyForecast(temperature: 18.5, uvIndex: 2.0, percipation: 0.1, hour: 9),
            HourlyForecast(temperature: 20.0, uvIndex: 5.0, percipation: 0.0, hour: 12),
            HourlyForecast(temperature: 21.5, uvIndex: 3.0, percipation: 0.0, hour: 15),
            HourlyForecast(temperature: 19.0, uvIndex: 1.0, percipation: 0.0, hour: 18)
        ]
    }

    public init(from weatherModelObject: WeatherModelObject) {
        let hourlyForecasts = Array(
            weatherModelObject.hourlyForecasts.map {
                HourlyForecast(
                    temperature: $0.temperature,
                    uvIndex: $0.uvIndex,
                    percipation: $0.percipation,
                    hour: $0.hour)
            })

        self.temperature = weatherModelObject.temperature
        self.feelsLike = weatherModelObject.feelsLike
        self.description = weatherModelObject.weatherDescription
        self.humidity = weatherModelObject.humidity
        self.speed = weatherModelObject.speed
        self.degrees = weatherModelObject.degrees
        self.sunrise = weatherModelObject.sunrise
        self.sunset = weatherModelObject.sunset
        self.minTemperature = weatherModelObject.minTemperature
        self.maxTemperature = weatherModelObject.maxTemperature
        self.statusId = weatherModelObject.statusId
        self.hourlyForecast = hourlyForecasts
    }

    public init(response: CurrentWeatherResponse, extraResponse: ExtraWeatherResponse) {
        let hourly: [HourlyForecast] = extraResponse.hourly.prefix(24).map { hourlyWeather in
            HourlyForecast(
                temperature: hourlyWeather.temperature,
                uvIndex: hourlyWeather.uvIndex,
                percipation: hourlyWeather.percipation,
                hour: hourlyWeather.dateTime)
        }

        self.temperature = response.main.temperature
        self.feelsLike = response.main.feelsLike
        self.description = response.weather.first?.description ?? "Not Avaliable"
        self.humidity = response.main.humidity
        self.speed = response.wind.speed
        self.degrees = response.wind.degrees
        self.sunrise = response.system.sunrise
        self.sunset = response.system.sunset
        self.minTemperature = response.main.minimalTemperature
        self.maxTemperature = response.main.maximalTemperature
        self.statusId = response.weather[0].id
        self.hourlyForecast = hourly
    }

}
