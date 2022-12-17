import Foundation

public struct NetworkConfig {
    public let endpoints: NetworkEndpoints

    public init(environment: NetworkEnvironment) {
        guard
            let path = Bundle.module.path(forResource: environment.rawValue, ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            let environmentDict = try? PropertyListSerialization.propertyList(
                from: data,
                options: .mutableContainers,
                format: nil
            ) as? [String: String]
        else { fatalError("Environment file is missing") }
        let timestamp = environmentDict["Marvel API timestamp"] ?? ""
        let key = environmentDict["Marvel API key"] ?? ""
        let hash = environmentDict["Marvel API hash"] ?? ""
        let charactersFormat = environmentDict["Marvel API characters url"] ?? ""
        let charactersByIdFormat = environmentDict["Marvel API characters by id url"] ?? ""
        let eventsFormat = environmentDict["Marvel API events url"] ?? ""
        endpoints = NetworkEndpoints(
            characters: .init(
                characterByIdFormat: String(format: charactersByIdFormat, "%d", key, timestamp, hash),
                charactersFormat: String(format: charactersFormat, key, timestamp, hash)
            ),
            events: .init(
                eventsFormat: String(format: eventsFormat, key, timestamp, hash)
            )
        )
    }
}
