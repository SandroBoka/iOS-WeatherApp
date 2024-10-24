import UIKit

protocol UseCaseDependenciesProtocol {

    var getWeatherUseCase: GetWeatherUseCaseProtocol { get }

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

    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(weatherService: weatherService)
    }()

    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = {
        GetWeatherUseCase(weatherRepo: weatherRepository)
    }()

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController, viewModelFactory: self)
    }()

}

extension Dependencies: ViewModelFactoryProtocol {

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(router: router, useCase: getWeatherUseCase)
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, useCase: getWeatherUseCase, city: cityName)
    }

}
