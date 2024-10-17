import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var homeScreenViewModel = HomeScreenViewModel()
    var body: some View {
        VStack {
            Text("Weather in Zagreb")
                .font(.title)
                .padding()

            if let weather = homeScreenViewModel.weather {
                Text("Temperature: \(weather.main.temp)°C")
                    .padding()
                Text("Feels Like: \(weather.main.feelsLike)°C")
                    .padding()
                Text("Weather: \(weather.weather.first?.description.capitalized ?? "N/A")")
                    .padding()
                Text("Humidity: \(weather.main.humidity)%")
                    .padding()
                Text("Wind Speed: \(weather.wind.speed) m/s")
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
    }
}

#Preview {
    HomeScreenView()
}
