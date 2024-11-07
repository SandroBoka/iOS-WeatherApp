import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel
    @State private var newCityName: String = ""

    init(viewModel: CityListViewModel) {
        let appearance = UINavigationBarAppearance()

        self.viewModel = viewModel

        setNavigationBarAppearance(appearance: appearance)
    }

    var body: some View {
        VStack {
            topInfo
                .padding(.horizontal, 30)
                .padding(.bottom)

            searchBar
                .padding(.horizontal)

            cityList
                .scrollContentBackground(.hidden)
        }
        .foregroundStyle(.primaryForeground)
        .background(.primaryBackground)
    }

    private var topInfo: some View {
        HStack {
            Text("Locations")
                .font(.dottedFont(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)

            EditButton()
        }
    }

    private var searchBar: some View {
        HStack {
            TextField(
                "",
                text: $newCityName,
                prompt: Text(.enterCityName).foregroundColor(.primaryForeground.opacity(0.5)))
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

            Button(.addCity) {
                guard !newCityName.isEmpty else { return }
                viewModel.addCity(cityName: newCityName)
                newCityName = ""
            }
        }
    }

    private var cityList: some View {
        List {
            ForEach(viewModel.cities) { city in
                Button {
                    viewModel.showDetailsForCity(city: city)
                } label: {
                    HStack {
                        Text(city.name.uppercased())
                            .font(.notoSansFont(size: 15))

                        Spacer()

                        if let temperature = city.temperature {
                            Text("\(temperature, specifier: "%.1f")°C")
                                .font(.dottedFont(size: 20))
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
    }

    private func setNavigationBarAppearance(appearance: UINavigationBarAppearance) {
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

}

#Preview {
    CityListView(
        viewModel: CityListViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
            getWeatherUseCase: GetWeatherUseCase(
                weatherRepository: WeatherRepository(
                    weatherService: WeatherService(client: NetworkClient()),
                    locationService: LocationService(client: NetworkClient()))),
            getCitiesUseCase: GetCitiesUseCase(dataRepository: DataRepository(dataService: DataService())),
            storeCitiesUseCase: StoreCitiesUseCase(dataRepository: DataRepository(dataService: DataService()))))
}
