import SwiftUI

struct WeatherScreenView: View {

    @ObservedObject var viewModel: CityScreenViewModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Text("Hello, world!").font(Font.custom("NDOT45inspiredbyNOTHING", size: 20))
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    WeatherScreenView(
        viewModel: CityScreenViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            useCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            city: "Atlantic City"
        )
    )
}
