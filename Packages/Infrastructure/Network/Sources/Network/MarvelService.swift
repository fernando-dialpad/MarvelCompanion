import Core
import Foundation
import SharedModels
import AnyCodable

public protocol MarvelService {
    func fetchMarvelCharacters() async throws -> [MarvelCharacter]
    func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter?
    func fetchMarvelEvents() async throws -> [MarvelEvent]
}

public final class NetworkMarvelService: MarvelService {
    @Dependency var config: NetworkConfig
    private lazy var decoder = MarvelJSONDecoder()

    public init() {}

    public func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let url = config.endpoints.characters.charactersURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decodeAll([MarvelCharacter].self, from: data)
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        let url = config.endpoints.characters.characterURL(for: id)
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decodeAll([MarvelCharacter].self, from: data).first
    }

    public func fetchMarvelEvents() async throws -> [MarvelEvent] {
        let url = config.endpoints.events.eventsURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decodeAll([MarvelEvent].self, from: data)
    }
}
