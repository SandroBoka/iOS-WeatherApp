import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel
    var body: some View {
        VStack {
            Text("Weather in Zagreb")
                .font(.title)
                .padding()

            if let weather = homeScreenViewModel.weather {
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
                Text("Sunrise: \(homeScreenViewModel.formatTimeFromUnix(weather.sys.sunrise, timeZoneOffset: 3600))")
                    .padding()
                Text("Sunset: \(homeScreenViewModel.formatTimeFromUnix(weather.sys.sunset, timeZoneOffset: 3600))")
                    .padding()
            } else {
                Text("Loading weather data...")
            }

            Spacer()
        }
        .padding()
        .task {
            await homeScreenViewModel.fetchWeatherZagreb()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue, .gray]),
                                   startPoint: .top, endPoint: .bottom).ignoresSafeArea())

    }
}

#Preview {
    HomeScreenView(
        homeScreenViewModel: HomeScreenViewModel(
            router: Router(navigationController: UINavigationController()),
            weatherService: WeatherService())
    )
}
