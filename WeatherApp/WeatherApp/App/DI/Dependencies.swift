import UIKit

protocol UseCaseDependenciesProtocol {

    var getWeatherUseCase: GetWeatherUseCaseProtocol { get }
    var getCitiesUseCase: GetCitiesUseCaseProtocol { get }
    var storeCitiesUseCase: StoreCitiesUseCaseProtocol { get }

}

protocol NavigationDependenciesProtocol {

    var router: RouterProtocol { get }

}

protocol ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel
    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel

}

typealias DependenciesProtocol = UseCaseDependenciesProtocol &
NavigationDependenciesProtocol

class Dependencies: DependenciesProtocol {

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

    private lazy var dataService: DataServiceProtocol = {
        DataService()
    }()

    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        return WeatherRepository(
            weatherService: weatherService,
            locationService: locationService,
            realmService: realmService)
    }()

    private lazy var dataRepository: DataRepositoryProtocol = {
        DataRepository(dataService: dataService)
    }()

    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = {
        GetWeatherUseCase(weatherRepo: weatherRepository)
    }()

    lazy var getCitiesUseCase: GetCitiesUseCaseProtocol = {
        GetCitiesUseCase(dataRepo: dataRepository)
    }()

    lazy var storeCitiesUseCase: StoreCitiesUseCaseProtocol = {
        StoreCitiesUseCase(dataRepo: dataRepository)
    }()

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(
            router: router,
            weatherUseCase: getWeatherUseCase,
            getCitiesUseCase: getCitiesUseCase,
            storeCitiesUseCase: storeCitiesUseCase
        )
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, useCase: getWeatherUseCase, city: cityName)
    }

}
