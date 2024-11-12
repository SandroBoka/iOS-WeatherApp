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

}

class HourlyForecastObject: Object {

    @Persisted var temperature: Double
    @Persisted var uvIndex: Double
    @Persisted var percipation: Double
    @Persisted var hour: Int

}
