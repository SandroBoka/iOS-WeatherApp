struct CurrentWeatherResponse: Decodable {

    let coordinates: CoordinatesResponse
    let weather: [WeatherResponse]
    let base: String
    let main: MainResponse
    let visibility: Int
    let wind: WindResponse
    let clouds: CloudsResponse
    let dateTime: Int
    let system: SystemResponse
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {

        case coordinates = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dateTime = "dt"
        case system = "sys"
        case timezone
        case id
        case name
        case cod

    }

}

struct CoordinatesResponse: Decodable {

    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {

        case longitude = "lon"
        case latitude = "lat"

    }

}

struct WeatherResponse: Decodable {

    let id: Int
    let main: String
    let description: String
    let icon: String

}

struct MainResponse: Decodable {

    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {

        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity

    }

}

struct WindResponse: Decodable {

    let speed: Double
    let deg: Int

}

struct CloudsResponse: Decodable {

    let all: Int

}

struct SystemResponse: Decodable {

    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int

}
