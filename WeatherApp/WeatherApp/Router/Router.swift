import SwiftUI

protocol RouterProtocol {

    func start(in window: UIWindow)
    func goBack()

    func showHomeScreen()
    func showCityList()
    func showCityWeather(city: City)

}

class Router: RouterProtocol {

    private let navigationController: UINavigationController
    private let weatherService: WeatherServiceProtocol
    private let weatherRepo: WeatherRepositoryProtocol
    private let getWeatherUseCase: GetWeatherUseCaseProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.weatherService = WeatherService(client: NetworkClient())
        self.weatherRepo = WeatherRepository(weatherService: weatherService)
        self.getWeatherUseCase = GetWeatherUseCase(weatherRepo: weatherRepo)
    }

    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showCityList()
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func showHomeScreen() {
        let viewModel = CityScreenViewModel(router: self, useCase: getWeatherUseCase, city: "Zagreb")
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showCityList() {
        let viewModel = CityListViewModel(router: self, useCase: getWeatherUseCase)
        let view = CityListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showCityWeather(city: City) {
        let viewModel = CityScreenViewModel(router: self, useCase: getWeatherUseCase, city: city.name)
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }

}
