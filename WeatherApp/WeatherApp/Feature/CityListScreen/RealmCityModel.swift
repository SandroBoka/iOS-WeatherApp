import Foundation

struct RealmCityModel: Identifiable {

    let name: String

    var id: UUID
    var temperature: Double

    init(city: CityListObject) {
        self.id = city.id
        self.name = city.name
        self.temperature = city.temperature
    }

}
