import AsyncAlgorithms
import Core
import Network
import SharedModels
import Storage
import Notifier

public final class MarvelDataManager {
    @Dependency private var marvelService: MarvelService
    @Dependency private var storageService: MarvelStorageService
    @Dependency private var notificationService: NotificationService
    private lazy var decoder = MarvelJSONDecoder()

    public init() {}

    public var newMarvelCharacters: AsyncStream<MarvelCharacter> {
        AsyncStream { continuation in
            Task {
                for await notification in notificationService.pushNotifications {
                    guard let character = try? decoder.decodeAll([MarvelCharacter].self, from: notification).first else { continue }
                    continuation.yield(character)
                }
            }
            Task {
                for await notification in notificationService.channelNotifications {
                    guard let character = try? decoder.decodeAll([MarvelCharacter].self, from: notification).first else { continue }
                    continuation.yield(character)
                }
            }
        }
    }

    public func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let localCharacters = try storageService.fetchMarvelCharacters()
        guard !localCharacters.isEmpty else {
            return try await marvelService.fetchMarvelCharacters()
        }
        return localCharacters
    }

    public func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        let localCharacter = try storageService.fetchMarvelCharacter(for: id)
        guard localCharacter != nil else {
            return try await marvelService.fetchMarvelCharacter(for: id)
        }
        return localCharacter
    }

    public func fetchMarvelEvents() async throws -> [MarvelEvent] {
        let localEvents = try storageService.fetchMarvelEvents()
        guard !localEvents.isEmpty else {
            return try await marvelService.fetchMarvelEvents()
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
