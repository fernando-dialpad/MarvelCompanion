import Foundation
import SharedModels

public protocol MarvelStorageService {
    func fetchMarvelCharacters() throws -> [MarvelCharacter]
    func fetchMarvelCharacter(for id: MarvelCharacter.ID) throws -> MarvelCharacter?
    func fetchMarvelEvents() throws -> [MarvelEvent]
    func saveMarvelCharacters(characters: [MarvelCharacter]) throws
    func saveMarvelEvents(events: [MarvelEvent]) throws
    func saveMarvelCharacter(character: MarvelCharacter) throws
}

public final class UserDefaultsMarvelStorageService: MarvelStorageService {
    private enum UserDefaultKeys: String {
        case characters
        case events
    }
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

    public func fetchMarvelCharacters() throws -> [MarvelCharacter] {
        guard let data = UserDefaults.standard.object(forKey: UserDefaultKeys.characters.rawValue) as? Data else {
            return []
        }
        return try decoder.decode([MarvelCharacter].self, from: data)
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) throws -> MarvelCharacter? {
        let characters = try fetchMarvelCharacters()
        return characters.first { $0.id == id }
    }

    public func fetchMarvelEvents() throws -> [MarvelEvent] {
        guard let data = UserDefaults.standard.object(forKey: UserDefaultKeys.events.rawValue) as? Data else {
            return []
        }
        return try decoder.decode([MarvelEvent].self, from: data)
    }

    public func saveMarvelCharacters(characters: [MarvelCharacter]) throws {
        let data = try encoder.encode(characters)
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.characters.rawValue)
    }

    public func saveMarvelEvents(events: [MarvelEvent]) throws {
        let data = try encoder.encode(events)
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.events.rawValue)
    }

    public func saveMarvelCharacter(character: MarvelCharacter) throws {
        var characters = try fetchMarvelCharacters()
        characters.removeAll { $0.id == character.id }
        characters.append(character)
        try saveMarvelCharacters(characters: characters)
    }


}
