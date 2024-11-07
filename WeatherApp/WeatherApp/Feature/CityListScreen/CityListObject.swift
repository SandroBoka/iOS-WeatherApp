import RealmSwift
import Foundation

class CityListObject: Object, Identifiable {

    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String = ""
    @Persisted var temperature: Double = 0.0

    convenience init(id: UUID, name: String, temperature: Double) {
        self.init()
        self.id = id
        self.name = name
        self.temperature = temperature
    }

}
