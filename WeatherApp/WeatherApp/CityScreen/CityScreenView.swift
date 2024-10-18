import SwiftUI

struct CityScreenView: View {
    let city: City
    @ObservedObject var cityScreenViewModel = CityScreenViewModel()
    var body: some View {
        VStack {
            Text("Weather in \(city.name)")
                .font(.title)
                .padding()

            if let weather = cityScreenViewModel.weather {
                Text("Temperature: \(String(format: "%.1f", weather.main.temp))°C")
                    .padding()
                Text("Feels Like: \(String(format: "%.1f", weather.main.feelsLike))°C")
                    .padding()
                Text("Weather: \(weather.weather.first?.description.capitalized ?? "N/A")")
                    .padding()
                Text("Humidity: \(weather.main.humidity)%")
                    .padding()
                Text("Wind Speed: \(String(format: "%.1f", weather.wind.speed)) m/s")
                    .padding()
                Text("Sunrise: \(cityScreenViewModel.formatTimeFromUnix(weather.sys.sunrise, timeZoneOffset: 3600))")
                    .padding()
                Text("Sunset: \(cityScreenViewModel.formatTimeFromUnix(weather.sys.sunset, timeZoneOffset: 3600))")
                    .padding()
            } else {
                Text("Loading weather data...")
            }

            Spacer()
        }
        .padding()
        .task {
            await cityScreenViewModel.fetchWeather(cityName: "New York")
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.6).ignoresSafeArea())

    }
}

#Preview {
    CityScreenView(city: City(name: "Atlantic City", temperature: 20.2))
}
