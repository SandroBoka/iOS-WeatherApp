import SwiftUI

protocol RouterProtocol {

    func start(in window: UIWindow)
    func goBack()

    func showCityList()
    func showCityWeather(city: City)

}

class Router: RouterProtocol {

    private let navigationController: UINavigationController
    private let viewModelFactory: ViewModelFactoryProtocol

    init(navigationController: UINavigationController, viewModelFactory: ViewModelFactoryProtocol) {
        self.navigationController = navigationController
        self.viewModelFactory = viewModelFactory

        navigationController.isNavigationBarHidden = true
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
        let viewModel = viewModelFactory.makeCityListViewModel()
        let view = CityListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showCityWeather(city: City) {
        let viewModel = viewModelFactory.makeCityScreenViewModel(city: city)
        let view = CityScreenView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

}
