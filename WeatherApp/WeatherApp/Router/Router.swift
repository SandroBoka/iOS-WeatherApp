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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.weatherService = WeatherService()
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
        let viewModel = CityScreenViewModel(router: self, service: weatherService, city: "Zagreb")
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showCityList() {
        let viewModel = CityListViewModel(router: self, service: weatherService)
        let view = CityListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showCityWeather(city: City) {
        let viewModel = CityScreenViewModel(router: self, service: weatherService, city: city.name)
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
