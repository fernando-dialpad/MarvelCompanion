import AsyncAlgorithms
import Core
import Network
import SharedModels
import Storage
import Notifier

public final class MarvelDataManager {
    @Dependency private var marvelService: MarvelService
    @Dependency private var storageService: StorageService
    @Dependency private var notificationService: NotificationService
    private lazy var decoder = MarvelJSONDecoder()

    public init() {}

    public func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let localCharacters: [MarvelCharacter] = try storageService.fetchAll()
        guard !localCharacters.isEmpty else {
            let remoteCharacters = try await marvelService.fetchMarvelCharacters()
            try storageService.saveAll(remoteCharacters)
            return remoteCharacters
        }
        return localCharacters
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        let localCharacter: MarvelCharacter? = try storageService.fetch(for: id)
        guard localCharacter != nil else {
            let remoteCharacter = try await marvelService.fetchMarvelCharacter(for: id)
            if let remoteCharacter = remoteCharacter {
                try storageService.save(remoteCharacter)
            }
            return remoteCharacter
        }
        return localCharacter
    }

    public func fetchMarvelEvents() async throws -> [MarvelEvent] {
        let localEvents: [MarvelEvent] = try storageService.fetchAll()
        guard !localEvents.isEmpty else {
            let remoteEvents = try await marvelService.fetchMarvelEvents()
            try storageService.saveAll(remoteEvents)
            return remoteEvents
        }
        return localEvents
    }

    public func saveMarvelCharacters(characters: [MarvelCharacter]) throws {
        try storageService.saveAll(characters)
    }

    public func saveMarvelEvents(events: [MarvelEvent]) throws {
        try storageService.saveAll(events)
    }
    
    public func saveMarvelCharacter(character: MarvelCharacter) throws {
        try storageService.save(character)
    }
}
