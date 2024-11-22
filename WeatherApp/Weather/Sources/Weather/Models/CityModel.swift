import Foundation

public struct City: Identifiable, Codable {

    public let id: Int
    public let name: String

    public var temperature: Double?

    public init(id: Int, name: String, temperature: Double? = nil) {
        self.id = id
        self.name = name
        self.temperature = temperature
    }

}
