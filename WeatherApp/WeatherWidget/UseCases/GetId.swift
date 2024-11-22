import Foundation

protocol GetCurrentLocationIdProtocol {

    func getId() -> Int

}

class GetCurrentLocationId: GetCurrentLocationIdProtocol {

    private let currentIdKey: String = "currentIdKey"

    func getId() -> Int {
        let id = UserDefaults.standard.integer(forKey: currentIdKey)
        print(id)
        return id
    }

}
