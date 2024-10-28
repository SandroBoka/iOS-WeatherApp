import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel
    @State private var newCityName: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("Locations")
                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 18))

                Spacer()

                EditButton()
            }
            .padding(.horizontal, 30)
            .padding(.bottom)

            HStack {
                TextField(
                    "",
                    text: $newCityName,
                    prompt: Text("Enter city name").foregroundColor(.primaryForeground.opacity(0.5))
                )
                .padding(8)
                .foregroundStyle(.primaryForeground)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

                Button("Add City") {
                    guard !newCityName.isEmpty else { return }
                    viewModel.addCity(cityName: newCityName)
                    newCityName = ""
                }
            }
            .padding(.horizontal)

            List {
                ForEach(viewModel.cities) { city in
                    Button {
                        viewModel.showDetailsForCity(city: city)
                    } label: {
                        HStack {
                            Text(city.name.uppercased())
                                .font(Font.custom("Noto Sans Mono", size: 15))

                            Spacer()

                            if let temperature = city.temperature {
                                Text("\(temperature, specifier: "%.1f")°C")
                                    .font(Font.custom("NDOT45inspiredbyNOTHING", size: 20))
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.gray.opacity(0.1))
                }
                .onDelete(perform: viewModel.removeCity)
            }
            .background(.primaryBackground)
            .scrollContentBackground(.hidden)
        }
        .foregroundStyle(.primaryForeground)
        .background(Color.primaryBackground)
    }
}

#Preview {
    CityListView(
        viewModel: CityListViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            weatherUseCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            getCitiesUseCase: GetCitiesUseCase(dataRepo: DataRepository(dataService: DataService())),
            storeCitiesUseCase: StoreCitiesUseCase(dataRepo: DataRepository(dataService: DataService()))
        )
    )
}
