import RealmSwift

class WeatherModelObject: Object {

    @Persisted(primaryKey: true) var cityId: Int
    @Persisted var cityName: String
    @Persisted var temperature: Double
    @Persisted var feelsLike: Double
    @Persisted var weatherDescription: String
    @Persisted var humidity: Int
    @Persisted var speed: Double
    @Persisted var degrees: Int
    @Persisted var sunrise: Int
    @Persisted var sunset: Int
    @Persisted var minTemperature: Double
    @Persisted var maxTemperature: Double
    @Persisted var statusId: Int
    @Persisted var hourlyForecasts = List<HourlyForecastObject>()

    init(weather: WeatherModel, cityId: Int, cityName: String) {
        super.init()

        self.cityId = cityId
        self.cityName = cityName
        self.temperature = weather.temperature
        self.feelsLike = weather.feelsLike
        self.weatherDescription = weather.description
        self.humidity = weather.humidity
        self.speed = weather.speed
        self.degrees = weather.degrees
        self.sunrise = weather.sunrise
        self.sunset = weather.sunset
        self.minTemperature = weather.minTemperature
        self.maxTemperature = weather.maxTemperature
        self.statusId = weather.statusId

        self.hourlyForecasts.append(objectsIn: weather.hourlyForecast.map {
            let hourlyForecastObject = HourlyForecastObject()
            hourlyForecastObject.temperature = $0.temperature
            hourlyForecastObject.uvIndex = $0.uvIndex
            hourlyForecastObject.percipation = $0.percipation
            hourlyForecastObject.hour = $0.hour
            return hourlyForecastObject
        })
    }

    required override init() {
        super.init()
    }

}

class HourlyForecastObject: Object {

    @Persisted var temperature: Double
    @Persisted var uvIndex: Double
    @Persisted var percipation: Double
    @Persisted var hour: Int

}
