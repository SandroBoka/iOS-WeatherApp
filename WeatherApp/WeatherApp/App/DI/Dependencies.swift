import UIKit
import Weather

protocol ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel
    func makeCityScreenViewModel(city: City) -> CityScreenViewModel

}

protocol SceneDelegateDependenciesProtocol {

    var router: RouterProtocol { get }

}

class Dependencies: SceneDelegateDependenciesProtocol {

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()

    lazy var realmService: RealmServiceProtocol = {
         RealmService()
     }()

    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = {
        GetWeatherUseCase(weatherRepository: weatherRepository)
    }()

    lazy var getCitiesUseCase: GetCitiesUseCaseProtocol = {
        GetCitiesUseCase(locationRepository: locationRepository, weatherRepository: weatherRepository)
    }()

    lazy var removeCityUseCase: RemoveCityUseCaseProtocol = {
        RemoveCityUseCase(locationRepository: locationRepository)
    }()

    lazy var getSuggestionsUseCase: GetSuggestionsUseCase = {
        GetSuggestionsUseCase(locationRepository: locationRepository)
    }()

    lazy var getIdUseCase: GetIdUseCaseProtocol = {
        GetIdUseCase(locationRepository: locationRepository)
    }()

    lazy var getLocationUseCase: GetLocationUseCaseProtocol = {
        GetLocationUseCase(locationRepository: locationRepository)
    }()

    lazy var userDefaultsUseCase: UserDefaultsUseCaseProtocol = {
        UserDefaultsUseCase()
    }()

    private lazy var mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)

        return navigationController
    }()

    private lazy var weatherClient: BaseApiClientProtocol = {
        NetworkClient()
    }()

    private lazy var locationManager: LocationDataManager = {
        LocationDataManager()
    }()

    private lazy var weatherService: WeatherServiceProtocol = {
        WeatherService(client: weatherClient)
    }()

    private lazy var locationService: LocationServiceProtocol = {
        LocationService(client: weatherClient)
    }()

    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        return WeatherRepository(
            weatherService: weatherService,
            locationService: locationService,
            realmService: realmService)
    }()

    private lazy var locationRepository: LocationRepositoryProtocol = {
        LocationRepository(realmService: realmService, locationManager: locationManager)
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(
            router: router,
            getWeatherUseCase: getWeatherUseCase,
            getCitiesUseCase: getCitiesUseCase,
            removeCityUseCase: removeCityUseCase,
            getSuggestionsUseCase: getSuggestionsUseCase,
            getIdUseCase: getIdUseCase,
            getLocationUseCase: getLocationUseCase,
            userDefaultsUseCase: userDefaultsUseCase)
    }

    func makeCityScreenViewModel(city: City) -> CityScreenViewModel {
        CityScreenViewModel(router: router, getWeatherUseCase: getWeatherUseCase, city: city)
    }

}
