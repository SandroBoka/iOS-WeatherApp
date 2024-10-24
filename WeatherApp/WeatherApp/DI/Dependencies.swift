import UIKit

protocol UseCaseDependenciesProtocol {

    var getWeatherUseCase: GetWeatherUseCaseProtocol { get }

}

protocol NavigationDependenciesProtocol {

    var router: RouterProtocol { get }

}

protocol ViewModelDependenciesProtocol {

    func makeCityListViewModel() -> CityListViewModel
    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel

}

typealias DependenciesProtocol = UseCaseDependenciesProtocol &
NavigationDependenciesProtocol &
ViewModelDependenciesProtocol

class Dependencies: DependenciesProtocol {

    private lazy var mainNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        return navigationController
    }()

    lazy var weatherClient: BaseApiClientProtocol = {
        NetworkClient()
    }()

    lazy var weatherService: WeatherServiceProtocol = {
        WeatherService(client: weatherClient)
    }()

    lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(weatherService: weatherService)
    }()

    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = {
        GetWeatherUseCase(weatherRepo: weatherRepository)
    }()

    lazy var router: RouterProtocol = {
        Router(navigationController: mainNavigationController)
    }()

    func makeCityListViewModel() -> CityListViewModel {
        CityListViewModel(router: router, useCase: getWeatherUseCase)
    }

    func makeCityScreenViewModel(cityName: String) -> CityScreenViewModel {
        CityScreenViewModel(router: router, useCase: getWeatherUseCase, city: cityName)
    }
}
