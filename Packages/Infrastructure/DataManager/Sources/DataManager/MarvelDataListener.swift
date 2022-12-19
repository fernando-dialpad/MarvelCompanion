import AsyncAlgorithms
import Core
import Network
import SharedModels
import Storage
import Notifier

public final class MarvelDataListener {
    @Dependency private var marvelService: MarvelService
    @Dependency private var storageService: StorageService
    @Dependency private var notificationService: NotificationService
    private lazy var decoder = MarvelJSONDecoder()

    public init() {}

    public var characterNotification: AsyncStream<MarvelCharacter> {
        AsyncStream { continuation in
            Task {
                let notifications = merge(
                    notificationService.pushNotifications,
                    notificationService.channelNotifications
                ).debounce(for: .milliseconds(300))
                for await notification in notifications {
                    guard let character = try? decoder.decodeAll([MarvelCharacter].self, from: notification).first else { continue }
                    continuation.yield(character)
                }
            }
        }
    }

    public var updatedCharacters: AsyncStream<[MarvelCharacter]> {
        AsyncStream { continuation in
            Task {
                for await characters in storageService.updatedData(of: MarvelCharacter.self) {
                    continuation.yield(characters)
                }
            }
        }
    }

    public var updatedEvents: AsyncStream<[MarvelEvent]> {
        AsyncStream { continuation in
            Task {
                for await events in storageService.updatedData(of: MarvelEvent.self) {
                    continuation.yield(events)
                }
            }
        }
    }
}
