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

                        NavigationBar(backAction: viewModel.goBack)
                            .padding(.horizontal)
                            .foregroundColor(.white)

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

                            TemperatureInfo(model: TemperatureInfo.Model(title: "Current", temperature: weather.temp))

                            Spacer()

                            TemperatureInfo(
                                model: TemperatureInfo.Model(title: "Feels Like", temperature: weather.feelsLike)
                            )

                            Spacer()
                        }

                        Divider()
                            .overlay(.white)
                            .padding(.top)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 18) {
                            WeatherWidget(
                                model: WeatherWidget.Model(title: "Wind", value: "\(weather.speed) km/h")
                            )
                            WeatherWidget(
                                model: WeatherWidget.Model(title: "Humidity", value: "\(weather.humidity) %")
                            )
                            WeatherWidget(
                                model: WeatherWidget.Model(
                                    title: "Sunrise",
                                    value: "\(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 3600))"
                                )
                            )
                            WeatherWidget(
                                model: WeatherWidget.Model(
                                    title: "Sunset",
                                    value: "\(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 3600))"
                                )
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
