import Foundation

struct City: Identifiable, Codable {

    let name: String

    var id = UUID()
    var temperature: Double?

}
