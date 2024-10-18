import SwiftUI

struct CityScreenView: View {
    @ObservedObject var viewModel: CityScreenViewModel
    var body: some View {
        VStack {
            Text("Weather in \(viewModel.city)")
                .font(.title)
                .padding()

            if let weather = viewModel.weather {
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
                Text("Sunrise: \(viewModel.formatTimeFromUnix(weather.sys.sunrise, timeZoneOffset: 3600))")
                    .padding()
                Text("Sunset: \(viewModel.formatTimeFromUnix(weather.sys.sunset, timeZoneOffset: 3600))")
                    .padding()
            } else {
                Text("Loading weather data...")
            }

            Spacer()
        }
        .padding()
        .task {
            await viewModel.fetchWeather()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue, .black]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())

    }
}

#Preview {
    CityScreenView(viewModel: CityScreenViewModel(router: Router(navigationController: UINavigationController()), city: "Atlantic City"))
}
