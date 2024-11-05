import SwiftUI

struct CityScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible())]

    var body: some View {
        VStack {
            NavigationBar(backAction: viewModel.goBack)
                .padding(.horizontal)
                .foregroundColor(.white)

            ScrollView {
                if viewModel.weather != nil {

                    mainInfo
                        .padding(.bottom)

                    temperatureInfo

                    Divider()
                        .overlay(.white)
                        .padding(.top)
                        .padding(.horizontal)

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

            TemperatureInfo(model: TemperatureInfo.Model(title: "Current", temperature: viewModel.weather!.temp))

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
    }

}

#Preview {
    CityScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            useCase: GetWeatherUseCase(
                weatherRepository: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            city: "Atlantic City"
        )
    )
}
