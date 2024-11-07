import RealmSwift

class CityObject: Object {

    @Persisted(primaryKey: true) var id: Int
    @Persisted var cityName: String

    convenience init(id: Int, cityName: String) {
        self.init()

        self.id = id
        self.cityName = cityName
    }

}
