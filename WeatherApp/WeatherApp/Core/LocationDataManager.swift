import CoreLocation
import Combine

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published var currentLocation: CLLocation?
    @Published var currentCityName: String = ""

    var locationManager = CLLocationManager()

    private let authorizationEnabledSubject = CurrentValueSubject<Bool, Never>(false)

    var authorizationEnabled: AnyPublisher<Bool, Never> {
        authorizationEnabledSubject
            .eraseToAnyPublisher()
    }

    override init() {
        super.init()

        locationManager.delegate = self
        authorizationStatus = locationManager.authorizationStatus
        currentLocation = CLLocation()
    }

    func requestLocation() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            authorizationEnabledSubject.send(true)
            manager.requestLocation()
            currentLocation = manager.location
            getCityName()

        case .authorizedAlways:
            authorizationStatus = .authorizedAlways
            authorizationEnabledSubject.send(true)
            manager.requestLocation()
            currentLocation = manager.location
            getCityName()

        case .restricted:
            authorizationStatus = .restricted
            authorizationEnabledSubject.send(false)

        case .denied:
            authorizationStatus = .denied
            authorizationEnabledSubject.send(false)

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: \(error.localizedDescription)")
    }

    func getCityName() {
        guard let location = currentLocation else { return }

        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first, let city = placemark.locality {
                self?.currentCityName = city
            } else {
                self?.currentCityName = ""
            }
        }
    }

}
