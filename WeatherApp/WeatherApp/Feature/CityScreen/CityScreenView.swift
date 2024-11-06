import SwiftUI

struct CityScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

    let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible())]

    var body: some View {
        if let weather = viewModel.weather {
            ScrollView {
                VStack {
                    NavBar(backAction: viewModel.goBack)

                    Text(viewModel.city)
                        .font(.dottedFont(size: 25))

                    viewModel
                        .weatherImage
                        .image
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(maxWidth: 170, maxHeight: 170)
                        .padding()

                    Text(weather.description.uppercased())
                        .font(.notoSansFont(size: 12))
                        .padding(.bottom, 20)

                    HStack(spacing: 24) {
                        Spacer()

                        TemperatureInfoView(
                            title: String(localized: "current_string"),
                            temperature: weather.temperature
                        )

                        Spacer()

                        TemperatureInfoView(
                            title: String(localized: "feels_like"),
                            temperature: weather.feelsLike
                        )

                        Spacer()
                    }

                    Divider()
                        .overlay(.primaryForeground)
                        .padding(.top)
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 18) {
                        SunriseWidgetView(
                            title: String(localized: "sunrise"),
                            value: "\(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 0))"
                        )

                        WindWidgetView(
                            title: String(localized: "wind"),
                            value: "\(weather.speed)",
                            deg: weather.degrees)

                        HumidityWidgetView(title: String(localized: "humidity"), value: "\(weather.humidity)")

                        SunsetWidgetView(
                            title: String(localized: "sunset"),
                            value: "\(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 0))"
                        )
                    }
                    .padding()

                    Divider()
                        .overlay(.primaryForeground)
                        .padding()

                    Text(.hourlyForecast)
                        .font(.notoSansFont(size: 14))

                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(weather.hourlyForecast, id: \.id) { hourly in
                                VStack {
                                    Text(viewModel.formatTimeFromUnix(hourly.hour, timeZoneOffset: 0))
                                        .font(.dottedFont(size: 18))

                                    HourlyForecastView(forecast: hourly)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .background {
                    Color.primaryBackground
                        .ignoresSafeArea()
                }
                .foregroundStyle(.primaryForeground)
            }
        }
    }

}

#Preview {
    CityScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            useCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(
                    weatherService: WeatherService(client: NetworkClient()),
                    locationService: LocationService(client: NetworkClient()), realmService: RealmService())),
            city: "Zagreb"
        )
    )
}
