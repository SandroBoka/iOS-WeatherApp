import SwiftUI

protocol RouterProtocol {

    func start(in window: UIWindow)
    func goBack()

    func showCityList()
    func showCityWeather(city: City)
}

class Router: RouterProtocol {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(in window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showCityList()
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func showCityList() {
        let viewModel = CityListViewModel(router: self)
        let view = CityListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showCityWeather(city: City) {
        let viewModel = CityScreenViewModel(router: self, city: city.name)
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: false)
    }
}
