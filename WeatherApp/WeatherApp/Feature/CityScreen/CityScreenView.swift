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

            ScrollView {
                VStack(spacing: 0) {
                    if viewModel.weather != nil {
                        scrollContent
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .background {
            Color
                .primaryBackground
                .ignoresSafeArea()
        }
        .foregroundStyle(.primaryForeground)
    }

    private var scrollContent: some View {
        VStack(spacing: 0) {
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

    private var mainInfo: some View {
        VStack(spacing: 10) {
            Text(viewModel.city.name)
                .font(.dottedFont(size: 25))

            viewModel
                .weatherImage
                .image
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

            TemperatureInfo(model: viewModel.getCurrentTemperatureModel())

            Spacer()

            TemperatureInfo(model: viewModel.getFeelsLikeTemperatureModel())

            Spacer()
        }
    }

    private var widgets: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            SunriseWidget(model: viewModel.getSunriseModel())

            WindWidget(model: viewModel.getWindModel())

            HumidityWidget(model: viewModel.getHumidtyModel())

            SunsetWidget(model: viewModel.getSunsetModel())
        }
    }

    private var hourly: some View {
        VStack {
            Text(.hourlyForecast)
                .font(.notoSansFont(size: 14))

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(viewModel.weather!.hourlyForecast, id: \.id) { hourly in
                        HourlyForecastWidget(forecast: hourly)
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
                    locationService: LocationService(client: NetworkClient()), realmService: RealmService())),
            city: City(id: 3186886, name: "Zagreb")))
}
