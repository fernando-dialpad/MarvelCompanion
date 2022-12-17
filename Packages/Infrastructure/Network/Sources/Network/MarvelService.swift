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

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    public init() {}

    public func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let url = config.endpoints.characters.charactersURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        let output = try decoder.decode([String: AnyDecodable].self, from: data)
        let outputData = output["data"]?.value as? [String: Any]
        let outputResults = try encoder.encode(AnyEncodable(outputData?["results"]))
        return try decoder.decode([MarvelCharacter].self, from: outputResults)
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        let url = config.endpoints.characters.characterURL(for: id)
        let (data, _) = try await URLSession.shared.data(from: url)
        let output = try decoder.decode([String: AnyDecodable].self, from: data)
        let outputData = output["data"]?.value as? [String: Any]
        let outputResults = try encoder.encode(AnyEncodable(outputData?["results"]))
        return try decoder.decode([MarvelCharacter].self, from: outputResults).first
    }

    public func fetchMarvelEvents() async throws -> [MarvelEvent] {
        let url = config.endpoints.events.eventsURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        let output = try decoder.decode([String: AnyDecodable].self, from: data)
        let outputData = output["data"]?.value as? [String: Any]
        let outputResults = try encoder.encode(AnyEncodable(outputData?["results"]))
        return try decoder.decode([MarvelEvent].self, from: outputResults)
    }
}
