import RealmSwift
import Foundation

class CityListObject: Object, Identifiable {

    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String = ""
    @Persisted var temperature: Double = 0.0

}
