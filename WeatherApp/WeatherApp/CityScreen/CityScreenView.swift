import SwiftUI

struct CityScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

    var body: some View {
        VStack {
            Text("Weather in \(viewModel.city)")
                .font(.title)
                .padding()

            if let weather = viewModel.weather {
                Text("Temperature: \(String(format: "%.1f", weather.temp))°C")
                    .padding()

                Text("Feels Like: \(String(format: "%.1f", weather.feelsLike))°C")
                    .padding()

                Text("Weather: \(weather.description.capitalized)")
                    .padding()

                Text("Humidity: \(weather.humidity)%")
                    .padding()

                Text("Wind Speed: \(String(format: "%.1f", weather.speed)) m/s")
                    .padding()

                Text("Sunrise: \(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 3600))")
                    .padding()

                Text("Sunset: \(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 3600))")
                    .padding()
            } else {
                Text("Loading weather data...")
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(gradient: Gradient(colors: [.white, .blue, .gray]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }

}

#Preview {
    CityScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController()),
            useCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            city: "Atlantic City"
        )
    )
}
