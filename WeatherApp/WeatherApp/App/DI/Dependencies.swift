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

    private lazy var dataService: DataServiceProtocol = {
        DataService()
    }()

    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(weatherService: weatherService)
    }()

    private lazy var dataRepository: DataRepositoryProtocol = {
        DataRepository(dataService: dataService)
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
            storeCitiesUseCase: storeCitiesUseCase)
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, getWeatherUseCase: getWeatherUseCase, city: cityName)
    }

}
