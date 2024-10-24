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
                            WeatherWidgetView(title: "Widget 1")
                            WeatherWidgetView(title: "Widget 2")
                            WeatherWidgetView(title: "Widget 3")
                            WeatherWidgetView(title: "Widget 4")
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
