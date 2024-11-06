import UIKit

<<<<<<< HEAD
protocol UseCaseDependenciesProtocol {

    var getWeatherUseCase: GetWeatherUseCaseProtocol { get }
    var getCitiesUseCase: GetCitiesUseCaseProtocol { get }
    var storeCitiesUseCase: StoreCitiesUseCaseProtocol { get }

}

protocol NavigationDependenciesProtocol {

    var router: RouterProtocol { get }

}

=======
>>>>>>> develop
protocol ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel
    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel

}

<<<<<<< HEAD
typealias DependenciesProtocol = UseCaseDependenciesProtocol &
NavigationDependenciesProtocol

class Dependencies: DependenciesProtocol {
=======
protocol SceneDelegateDependenciesProtocol {

    var router: RouterProtocol { get }

}

class Dependencies: SceneDelegateDependenciesProtocol {

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()
>>>>>>> develop

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
<<<<<<< HEAD
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
=======
        GetWeatherUseCase(weatherRepository: weatherRepository)
    }()

    lazy var getCitiesUseCase: GetCitiesUseCaseProtocol = {
        GetCitiesUseCase(dataRepository: dataRepository)
    }()

    lazy var storeCitiesUseCase: StoreCitiesUseCaseProtocol = {
        StoreCitiesUseCase(dataRepository: dataRepository)
>>>>>>> develop
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(
            router: router,
<<<<<<< HEAD
            weatherUseCase: getWeatherUseCase,
            getCitiesUseCase: getCitiesUseCase,
            storeCitiesUseCase: storeCitiesUseCase
        )
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, useCase: getWeatherUseCase, city: cityName)
=======
            getWeatherUseCase: getWeatherUseCase,
            getCitiesUseCase: getCitiesUseCase,
            storeCitiesUseCase: storeCitiesUseCase)
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, getWeatherUseCase: getWeatherUseCase, city: cityName)
>>>>>>> develop
    }

}
