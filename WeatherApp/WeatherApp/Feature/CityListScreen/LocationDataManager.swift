import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var authorizationStatus: CLAuthorizationStatus?

    var locationManager = CLLocationManager()

    override init() {
        super.init()

        locationManager.delegate = self
        authorizationStatus = locationManager.authorizationStatus
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
        print(locations.first?.coordinate ?? "No location available")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error: \(error.localizedDescription)")
    }

}
