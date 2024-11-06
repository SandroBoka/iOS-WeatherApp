import SwiftUI

struct CityScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

<<<<<<< HEAD
    let columns = [
=======
    private let columns = [
>>>>>>> develop
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible())]

    var body: some View {
<<<<<<< HEAD
        if let weather = viewModel.weather {
            ScrollView {
                VStack {

                    NavigationBar(backAction: viewModel.goBack)

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
=======
        VStack {
            NavigationBar(backAction: viewModel.goBack)
                .padding(.horizontal)
                .foregroundColor(.white)

            ScrollView {
                if viewModel.weather != nil {

                    mainInfo
                        .padding(.bottom)

                    temperatureInfo
>>>>>>> develop

                    Divider()
                        .overlay(.white)
                        .padding(.top)
                        .padding(.horizontal)

<<<<<<< HEAD
                    LazyVGrid(columns: columns, spacing: 18) {
                        SunriseWidget(
                            model: SunriseWidget.Model(
                                title: String(localized: "sunrise"),
                                value: "\(viewModel.formatTimeFromUnix(weather.sunrise, timeZoneOffset: 3600))"))

                        WindWidgetView(title: String(localized: "wind"), value: "\(weather.speed)", deg: weather.deg)

                        HumidityWidget(
                            model: HumidityWidget.Model(
                                title: String(localized: "humidity"),
                                value: "\(weather.humidity)"))

                        SunsetWidget(
                            model: SunsetWidget.Model(
                                title: String(localized: "sunset"),
                                value: "\(viewModel.formatTimeFromUnix(weather.sunset, timeZoneOffset: 3600))"
                            )
                        )
                    }
                    .padding()
                }
                .background {
                    Color.primaryBackground
                        .ignoresSafeArea()
                }
                .foregroundStyle(.primaryForeground)
            }
        }
=======
                    widgets
                        .padding()
                }
            }
        }
        .foregroundStyle(Color.white)
        .background {
            Color.black
                .ignoresSafeArea()
        }
    }

    private var mainInfo: some View {
        VStack(spacing: 10) {
            Text(viewModel.city)
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 25))

            Image(.sunny)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 170, maxHeight: 170)

            Text(viewModel.weather!.description.uppercased())
                .font(Font.custom("Noto Sans Mono", size: 12))
        }
    }

    private var temperatureInfo: some View {
        HStack(spacing: 24) {
            Spacer()

            TemperatureInfo(model: TemperatureInfo.Model(title: "Current", temperature: viewModel.weather!.temperature))

            Spacer()

            TemperatureInfo(
                model: TemperatureInfo.Model(title: "Feels Like", temperature: viewModel.weather!.feelsLike))

            Spacer()
        }
    }

    private var widgets: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            WeatherWidget(
                model: WeatherWidget.Model(title: "Wind", value: "\(viewModel.weather!.speed) km/h")
            )

            WeatherWidget(
                model: WeatherWidget.Model(title: "Humidity", value: "\(viewModel.weather!.humidity) %")
            )

            WeatherWidget(
                model: WeatherWidget.Model(
                    title: "Sunrise",
                    value: "\(viewModel.formatTimeFromUnix(viewModel.weather!.sunrise, timeZoneOffset: 3600))"
                )
            )

            WeatherWidget(
                model: WeatherWidget.Model(
                    title: "Sunset",
                    value: "\(viewModel.formatTimeFromUnix(viewModel.weather!.sunset, timeZoneOffset: 3600))"
                )
            )
        }
>>>>>>> develop
    }

}

#Preview {
    CityScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
<<<<<<< HEAD
            useCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            city: "Atlantic City"
        )
    )
=======
            getWeatherUseCase: GetWeatherUseCase(
                weatherRepository: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))),
            city: "Atlantic City"))
>>>>>>> develop
}
