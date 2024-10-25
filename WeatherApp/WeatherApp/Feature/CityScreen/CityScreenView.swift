import SwiftUI

struct CityScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

    let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if let weather = viewModel.weather {
                ScrollView {
                    VStack {
                        Text(viewModel.city)
                            .font(Font.custom("NDOT45inspiredbyNOTHING", size: 25))

                        Image(.sunny)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 170, maxHeight: 170)
                            .padding()

                        Text(weather.description.uppercased())
                            .font(Font.custom("Noto Sans Mono", size: 12))
                            .padding(.bottom, 20)

                        HStack(spacing: 24) {
                            Spacer()

                            TemperatureInfoView(title: "Current", temperature: weather.temp)

                            Spacer()

                            TemperatureInfoView(title: "Feels Like", temperature: weather.feelsLike)

                            Spacer()
                        }

                        Divider()
                            .overlay(.white)
                            .padding(.top)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 18) {
                            WeatherWidgetView(title: "Wind", value: "\(weather.speed) km/h")
                            WeatherWidgetView(title: "Humidity", value: "\(weather.humidity) %")
                            WeatherWidgetView(
                                title: "Sunrise",
                                value: "\(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 3600))"
                            )
                            WeatherWidgetView(
                                title: "Sunset",
                                value: "\(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 3600))"
                            )
                        }
                        .padding()

                        Spacer()
                    }
                    .foregroundStyle(Color.white)
                }
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
