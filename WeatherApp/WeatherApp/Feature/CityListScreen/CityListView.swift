import SwiftUI

struct CityListView: View {

    @ObservedObject var viewModel: CityListViewModel

    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            topInfo
                .padding(.horizontal, 30)
                .padding(.bottom)

            searchBar
                .padding(.horizontal)

            if !viewModel.suggestedCities.isEmpty {
                suggestedCityList
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
            }

            cityList
                .scrollContentBackground(.hidden)
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            setNavigationBarAppearance(appearance: appearance)
            viewModel.requestLocationAccess()
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
                text: $viewModel.newCityName,
                prompt: Text("Enter city name").foregroundColor(.primaryForeground.opacity(0.5))
            )
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

            Button("Add City") {
                viewModel.addCity()
            }
        }
    }

    private var suggestedCityList: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.suggestedCities, id: \.id) { city in
                Button(action: {
                    viewModel.newCityName = city.cityName
                    viewModel.suggestedCities = []
                }, label: {
                    Text(city.cityName)
                        .font(.notoSansFont(size: 15))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .buttonStyle(.bordered)
                .tint(Color.gray.opacity(0.5))
            }
        }
        .cornerRadius(10)
    }

    private var suggestedCityList: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.suggestedCities, id: \.id) { city in
                Button(action: {
                    viewModel.newCityName = city.cityName
                    viewModel.suggestedCities = []
                }, label: {
                    Text(city.cityName)
                        .font(.notoSansFont(size: 15))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .buttonStyle(.bordered)
                .tint(Color.gray.opacity(0.5))
            }
        }
        .cornerRadius(10)
    }

    private var cityList: some View {
        List {
            if viewModel.locationEnabled, let currentCity = viewModel.cities.first(
                where: { $0.id == viewModel.getCurrentCityId()
                }) {
                    CurrentListItem(city: currentCity, action: { selectedCity in
                        viewModel.showDetailsForCity(city: selectedCity)
                    })
                    .padding(.vertical, 8)
                    .listRowBackground(Color.gray.opacity(0.1))
            }
            ForEach(viewModel.cities.filter { $0.id != viewModel.getCurrentCityId() }) { city in
                CityListItem(city: city, action: { selectedCity in
                    viewModel.showDetailsForCity(city: selectedCity) })
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
                    locationService: LocationService(client: NetworkClient()), realmService: RealmService())),
            getCitiesUseCase: GetCitiesUseCase(
                locationRepository: LocationRepository(
                    realmService: RealmService(),
                    locationManager: LocationDataManager()),
                weatherRepository: WeatherRepository(
                    weatherService: WeatherService(client: NetworkClient()),
                    locationService: LocationService(client: NetworkClient()), realmService: RealmService())
            ),
            removeCityUseCase: RemoveCityUseCase(
                locationRepository: LocationRepository(
                    realmService: RealmService(),
                    locationManager: LocationDataManager())),
            getSuggestionsUseCase: GetSuggestionsUseCase(
                locationRepository: LocationRepository(
                    realmService: RealmService(),
                    locationManager: LocationDataManager())),
            getIdUseCase: GetIdUseCase(
                locationRepository: LocationRepository(
                    realmService: RealmService(),
                    locationManager: LocationDataManager())),
            getLocationUseCase: GetLocationUseCase(
                locationRepository: LocationRepository(
                    realmService: RealmService(),
                    locationManager: LocationDataManager())),
            userDefaultsUseCase: UserDefaultsUseCase()))
}
