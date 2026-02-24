import Foundation

protocol UserDefaultsUseCaseProtocol {

    func saveCurrentId(id: Int)
    func getCurrentId() -> Int

}

class UserDefaultsUseCase: UserDefaultsUseCaseProtocol {

    private let currentIdKey: String = "currentIdKey"

    func saveCurrentId(id: Int) {
        UserDefaults.standard.set(id, forKey: currentIdKey)
        print("saved \(id)")
    }

    func getCurrentId() -> Int {
        UserDefaults.standard.integer(forKey: currentIdKey)
    }

}
