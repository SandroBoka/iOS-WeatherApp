import Foundation

protocol GetCurrentLocationIdProtocol {

    func getId() -> Int

}

class GetCurrentLocationId: GetCurrentLocationIdProtocol {

    private let currentIdKey: String = "currentIdKey"

    func getId() -> Int {
        UserDefaults.standard.integer(forKey: currentIdKey)
    }

}
