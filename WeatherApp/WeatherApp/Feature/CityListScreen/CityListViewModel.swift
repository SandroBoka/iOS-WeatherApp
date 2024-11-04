import SwiftUI
import RealmSwift

class CityListViewModel: ObservableObject {

    @Published var cities: [City] = [] {
        didSet {
            storeCitiesUseCase.storeCities(cities: cities)
        }
    }

    private let router: RouterProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let getCitiesUseCase: GetCitiesUseCaseProtocol
    private let storeCitiesUseCase: StoreCitiesUseCaseProtocol

    init(
        router: RouterProtocol,
        weatherUseCase: GetWeatherUseCaseProtocol,
        getCitiesUseCase: GetCitiesUseCaseProtocol,
        storeCitiesUseCase: StoreCitiesUseCaseProtocol
    ) {
        self.router = router
        self.getWeatherUseCase = weatherUseCase
        self.getCitiesUseCase = getCitiesUseCase
        self.storeCitiesUseCase = storeCitiesUseCase

        cities = getCitiesUseCase.getCities()
        fetchWeatherForAllCities()
    }

    func fetchTemperature(for city: City) {
        getWeatherUseCase.getWeather(cityName: city.name) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let weatherModel):
                if let index = self.cities.firstIndex(where: { $0.id == city.id }) {
                    DispatchQueue.main.sync { [weak self] in
                        self?.cities[index].temperature = weatherModel.temperature
                    }
                }
                try? self.saveTemperatureToRealm(cityID: city.id, name: city.name, temperature: city.temperature ?? -1)
            case .failure(let error):
                print("Error fetching temperature for \(city.name): \(error)")
                try? self.loadLastSavedTemperature(for: city)
            }
        }
    }

    func fetchWeatherForAllCities() {
        for city in cities {
            fetchTemperature(for: city)
        }
    }

    func showDetailsForCity(city: City) {
        router.showCityWeather(city: city)
    }

    func addCity(cityName: String) {
        let newCity = City(name: cityName)
        cities.append(newCity)
        fetchTemperature(for: newCity)
    }

    func removeCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
    }

}

enum CityListError: Error {
    case realmInitializationFailed
    case cityNotFoundInRealm
    case objectIdCreationFailed
}

extension CityListViewModel {

    private func saveTemperatureToRealm(cityID: UUID, name: String, temperature: Double) throws {
        guard let realm = try? Realm() else { throw CityListError.realmInitializationFailed }

        if let realmCity = realm.object(ofType: CityListObject.self, forPrimaryKey: cityID) {
            try realm.write {
                realmCity.temperature = temperature
            }
        } else {
            let newRealmCity = CityListObject()
            newRealmCity.id = cityID
            newRealmCity.name = name
            newRealmCity.temperature = temperature

            try realm.write {
                realm.add(newRealmCity)
            }
        }
    }

    private func loadLastSavedTemperature(for city: City) throws {
        guard let realm = try? Realm() else { throw CityListError.realmInitializationFailed }

        guard let savedCity = realm.object(ofType: CityListObject.self, forPrimaryKey: city.id) else {
            throw CityListError.cityNotFoundInRealm
        }

        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            DispatchQueue.main.async { [weak self] in
                self?.cities[index].temperature = savedCity.temperature
            }
        }
    }

}
