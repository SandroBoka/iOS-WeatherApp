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
    private let viewModelFactory: ViewModelDependenciesProtocol

    init(navigationController: UINavigationController, viewModelFactory: ViewModelDependenciesProtocol) {
        self.navigationController = navigationController
        self.viewModelFactory = viewModelFactory
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
        let viewModel = viewModelFactory.makeCityScreenViewModel(cityName: "Zagreb")
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }

    func showCityList() {
        let viewModel = viewModelFactory.makeCityListViewModel()
        let view = CityListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showCityWeather(city: City) {
        let viewModel = viewModelFactory.makeCityScreenViewModel(cityName: city.name)
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

}
