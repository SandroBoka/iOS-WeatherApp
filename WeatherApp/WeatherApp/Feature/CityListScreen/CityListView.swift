import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel
    @State private var newCityName: String = ""

<<<<<<< HEAD
    var body: some View {
        VStack {
            HStack {
                Text(.cityListTitle)
                    .font(.dottedFont(size: 18))

                Spacer()

                EditButton()
            }
            .padding(.horizontal, 30)
            .padding(.bottom)

            HStack {
                TextField(
                    "",
                    text: $newCityName,
                    prompt: Text(.enterCityName).foregroundColor(.primaryForeground.opacity(0.5))
                )
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

                Button(.addCity) {
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
            .scrollContentBackground(.hidden)
        }
        .foregroundStyle(.primaryForeground)
        .background(Color.primaryBackground)
    }
=======
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
                .background(Color.black)
                .scrollContentBackground(.hidden)
        }
        .foregroundStyle(Color.white)
        .background(Color.black)
    }

    private var topInfo: some View {
        HStack {
            Text("Locations")
                .foregroundColor(.white)
                .font(Font.custom("NDOT45inspiredbyNOTHING", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)

            EditButton()
        }
    }

    private var searchBar: some View {
        HStack {
            TextField(
                "",
                text: $newCityName,
                prompt: Text("Enter city name").foregroundColor(.white.opacity(0.5))
            )
            .padding(8)
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

            Button("Add City") {
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
                            .font(Font.custom("Noto Sans Mono", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let temperature = city.temperature {
                            Text("\(temperature, specifier: "%.1f")°C")
                                .foregroundColor(.white)
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
    }

    private func setNavigationBarAppearance(appearance: UINavigationBarAppearance) {
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

>>>>>>> develop
}

#Preview {
    CityListView(
        viewModel: CityListViewModel(
            router: Router(navigationController: UINavigationController(), viewModelFactory: Dependencies()),
<<<<<<< HEAD
            weatherUseCase: GetWeatherUseCase(
                weatherRepo: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))
            ),
            getCitiesUseCase: GetCitiesUseCase(dataRepo: DataRepository(dataService: DataService())),
            storeCitiesUseCase: StoreCitiesUseCase(dataRepo: DataRepository(dataService: DataService()))
        )
    )
=======
            getWeatherUseCase: GetWeatherUseCase(
                weatherRepository: WeatherRepository(weatherService: WeatherService(client: NetworkClient()))),
            getCitiesUseCase: GetCitiesUseCase(dataRepository: DataRepository(dataService: DataService())),
            storeCitiesUseCase: StoreCitiesUseCase(dataRepository: DataRepository(dataService: DataService()))))
>>>>>>> develop
}
