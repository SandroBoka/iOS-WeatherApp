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

}

extension WeatherModel {

    init(from weatherModelObject: WeatherModelObject) {

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

}
