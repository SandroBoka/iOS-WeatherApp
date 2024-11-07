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
                        .overlay(.primaryForeground)
                        .padding()

                    widgets
                        .padding()

                    Divider()
                        .overlay(.primaryForeground)
                        .padding()

                    hourly
                }
            }
        }
        .background {
            Color.primaryBackground
                .ignoresSafeArea()
        }
        .foregroundStyle(.primaryForeground)
    }

    private var mainInfo: some View {
        VStack(spacing: 10) {
            Text(viewModel.city)
                .font(.dottedFont(size: 25))

            Image(.sunny)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(maxWidth: 170, maxHeight: 170)

            Text(viewModel.weather!.description.uppercased())
                .font(.notoSansFont(size: 12))
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
            SunriseWidget(
                model: SunriseWidget.Model(
                    title: String(localized: "sunrise"),
                    value: "\(viewModel.formatTimeFromUnix(viewModel.weather!.sunrise, timeZoneOffset: 0))"))

            WindWidget(
                model: WindWidget.Model(
                    title: String(localized: "wind"),
                    value: "\(viewModel.weather!.speed)",
                    degree: Double(viewModel.weather!.degrees)))

            HumidityWidget(
                model: HumidityWidget.Model(
                    title: String(localized: "humidity"),
                    value: "\(viewModel.weather!.humidity)"))

            SunsetWidget(
                model: SunsetWidget.Model(
                    title: String(localized: "sunset"),
                    value: "\(viewModel.formatTimeFromUnix(viewModel.weather!.sunset, timeZoneOffset: 0))"))
        }
    }

    private var hourly: some View {
        VStack {
            Text(.hourlyForecast)
                .font(.notoSansFont(size: 14))

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(viewModel.weather!.hourlyForecast, id: \.id) { hourly in
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
    }

}

#Preview {
    CityScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            getWeatherUseCase: GetWeatherUseCase(
                weatherRepository: WeatherRepository(
                    weatherService: WeatherService(client: NetworkClient()),
                    locationService: LocationService(client: NetworkClient()))),
            city: "Zagreb"))
}
