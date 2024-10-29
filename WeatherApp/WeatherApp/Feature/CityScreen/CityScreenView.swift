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

                    Image(.sunny)
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

                        TemperatureInfoView(title: String(localized: "current_string"), temperature: weather.temp)

                        Spacer()

                        TemperatureInfoView(title: String(localized: "feels_like"), temperature: weather.feelsLike)

                        Spacer()
                    }

                    Divider()
                        .overlay(.white)
                        .padding(.top)
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 18) {
                        SunriseWidgetView(
                            title: String(localized: "sunrise"),
                            value: "\(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 3600))"
                        )
                        WindWidgetView(title: String(localized: "wind"), value: "\(weather.speed)", deg: weather.deg)
                        HumidityWidgetView(title: String(localized: "humidity"), value: "\(weather.humidity)")
                        SunsetWidgetView(
                            title: String(localized: "sunset"),
                            value: "\(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 3600))"
                        )
                    }
                    .padding()

                    Spacer()
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
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            city: "Atlantic City"
        )
    )
}
