import Core
import Network
import SharedModels
import Storage

public final class MarvelDataManager {
    @Dependency var restService: MarvelRestService
    @Dependency var storageService: MarvelStorageService

    public init() {}

    public func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let localCharacters = try storageService.fetchMarvelCharacters()
        guard !localCharacters.isEmpty else {
            return try await restService.fetchMarvelCharacters()
        }
        return localCharacters
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        let localCharacter = try storageService.fetchMarvelCharacter(for: id)
        guard localCharacter != nil else {
            return try await restService.fetchMarvelCharacter(for: id)
        }
        return localCharacter
    }

    public func fetchMarvelEvents() async throws -> [MarvelEvent] {
        let localEvents = try storageService.fetchMarvelEvents()
        guard !localEvents.isEmpty else {
            return try await restService.fetchMarvelEvents()
        }
        return localEvents
    }

    public func saveMarvelCharacters(characters: [MarvelCharacter]) async throws {
        try storageService.saveMarvelCharacters(characters: characters)
    }

    public func saveMarvelEvents(events: [MarvelEvent]) async throws {
        try storageService.saveMarvelEvents(events: events)
    }
    
    public func saveMarvelCharacter(character: MarvelCharacter) async throws {
        try storageService.saveMarvelCharacter(character: character)
    }
}
