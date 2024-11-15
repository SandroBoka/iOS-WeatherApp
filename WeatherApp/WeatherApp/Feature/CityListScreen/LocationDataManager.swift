import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var currentLocation: CLLocation?

    var locationManager = CLLocationManager()

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
            manager.requestLocation()

        case .authorizedAlways:
            authorizationStatus = .authorizedAlways
            manager.requestLocation()

        case .restricted:
            authorizationStatus = .restricted

        case .denied:
            authorizationStatus = .denied

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

}
