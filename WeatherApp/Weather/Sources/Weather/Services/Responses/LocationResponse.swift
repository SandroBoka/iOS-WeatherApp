public struct LocationResponse: Decodable {

    let name: String
    let localNames: [String: String]?
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {

        case name
        case localNames
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state

    }

}
