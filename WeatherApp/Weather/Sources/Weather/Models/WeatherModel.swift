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
