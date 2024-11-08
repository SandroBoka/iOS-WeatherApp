import UIKit

protocol ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel
    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel

}

protocol SceneDelegateDependenciesProtocol {

    var router: RouterProtocol { get }

}

class Dependencies: SceneDelegateDependenciesProtocol {

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()

    private lazy var mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)

        return navigationController
    }()

    private lazy var weatherClient: BaseApiClientProtocol = {
        NetworkClient()
    }()

    private lazy var weatherService: WeatherServiceProtocol = {
        WeatherService(client: weatherClient)
    }()

    private lazy var locationService: LocationServiceProtocol = {
        LocationService(client: weatherClient)
    }()

    private lazy var realmService: RealmServiceProtocol = {
        RealmService()
    }()

    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        return WeatherRepository(
            weatherService: weatherService,
            locationService: locationService,
            realmService: realmService)
    }()

    private lazy var dataRepository: DataRepositoryProtocol = {
        DataRepository(realmService: realmService)
    }()

    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = {
        GetWeatherUseCase(weatherRepository: weatherRepository)
    }()

    lazy var getCitiesUseCase: GetCitiesUseCaseProtocol = {
        GetCitiesUseCase(dataRepository: dataRepository)
    }()

    lazy var storeCitiesUseCase: StoreCitiesUseCaseProtocol = {
        StoreCitiesUseCase(dataRepository: dataRepository)
    }()

    lazy var getSuggestionsUseCase: GetSuggestionsUseCase = {
        GetSuggestionsUseCase(dataRepository: dataRepository)
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(
            router: router,
            getWeatherUseCase: getWeatherUseCase,
            getCitiesUseCase: getCitiesUseCase,
            storeCitiesUseCase: storeCitiesUseCase,
            getSuggestionsUseCase: getSuggestionsUseCase)
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, getWeatherUseCase: getWeatherUseCase, city: cityName)
    }

}
