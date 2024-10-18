import SwiftUI

class CityListViewModel: ObservableObject {

    @Published var cities: [City] = [
        City(name: "Zagreb"),
        City(name: "Paris"),
        City(name: "New York"),
        City(name: "Tokyo"),
        City(name: "London")
    ]

    private let apiKey = "ff4cd4d2c654b4100a2712f4cbaeb732" // remove

    func fetchTemperature(for city: City) async {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city.name),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = urlComponents.url else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
            if let index = cities.firstIndex(where: { $0.id == city.id }) {
                DispatchQueue.main.async {
                    self.cities[index].temperature = decodedData.main.temp
                }
            }
        } catch {
            print("Error fetching temperature for \(city.name): \(error)")
        }
    }

    func fetchWeatherForAllCities() async {
        for city in cities {
            await fetchTemperature(for: city)
        }
    }
}
