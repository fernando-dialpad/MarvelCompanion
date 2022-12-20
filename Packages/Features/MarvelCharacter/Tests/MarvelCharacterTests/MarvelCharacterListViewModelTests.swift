import XCTest
@testable import MarvelCharacter
@testable import Network
@testable import Notifier
@testable import Storage
@testable import DataManager
@testable import Core
@testable import SharedModels

final class MarvelCharacterListViewModelTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        injectDependencies()
    }

    func testUnfavorite() async throws {
        let viewModel = MarvelCharacterListViewModel()
        try await viewModel.load()

        // Given a list of favorites ranked
        let originalRanks = viewModel.characterViewModels.value.map(\.character.value.favoriteRank)
        XCTAssertEqual(originalRanks, [.favorited(rank: 1), .favorited(rank: 2), .favorited(rank: 3), .favorited(rank: 4)])

        // When we toggle a favorite (and wait the view to receive update)
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { try await viewModel.characterViewModels.value[1].toggleFavorite() }
            group.addTask { await viewModel.dataListener.updatedCharacters.waitForElements(count: 2) }
        }

        // Then the element will be non favorited and the ranks reorganized
        let updatedRanks = viewModel.characterViewModels.value.map(\.character.value.favoriteRank)
        XCTAssertEqual(updatedRanks, [.favorited(rank: 1), .notFavorited, .favorited(rank: 2), .favorited(rank: 3)])
    }

    private func injectDependencies() {
        DependencyContainer.register(NetworkConfig.self, value: NetworkConfig(environment: .defaultEnvironment))
        DependencyContainer.register(NotifierConfig.self, value: NotifierConfig(environment: .defaultEnvironment))
        DependencyContainer.register(UserNotificationService.self, value: AppleUserNotificationService(), singleton: true)
        DependencyContainer.register(RemoteNotificationService.self, value: AblyRemoteNotificationService(), singleton: true)
        DependencyContainer.register(MarvelService.self, value: MockMarvelService())
        DependencyContainer.register(ImageService.self, value: NetworkImageService(), singleton: true)
        let userDefaults = UserDefaults(suiteName: "TestSuite") ?? .standard
        userDefaults.removePersistentDomain(forName: "TestSuite")
        DependencyContainer.register(StorageService.self, value: UserDefaultsStorageService(userDefaults: userDefaults))
        DependencyContainer.register(MarvelDataManager.self, value: MarvelDataManager())
        DependencyContainer.register(MarvelDataListener.self, value: MarvelDataListener())
        DependencyContainer.register(NotificationService.self, value: NotificationService())
    }
}

final class MockMarvelService: MarvelService {
    @Dependency private var storageService: StorageService

    func fetchMarvelCharacters() async throws -> [MarvelCharacter] {
        let characters: [MarvelCharacter] = try storageService.fetchAll()
        if characters.isEmpty {
            return (0..<4).map { i in
                MarvelCharacter(
                    id: i+1,
                    name: "Name",
                    description: "Description",
                    thumbnailURL: URL(string: "https://google.com")!,
                    availableStories: 1234,
                    modifiedDate: Date.now.addingTimeInterval(Double(60 * i)),
                    events: [],
                    favoriteRank: .favorited(rank: i+1)
                )
            }
        } else {
            return characters
        }
    }

    func fetchMarvelCharacter(for id: MarvelCharacter.ID) async throws -> MarvelCharacter? {
        try storageService.fetch(for: id)
    }

    func fetchMarvelEvents() async throws -> [MarvelEvent] {
        try storageService.fetchAll()
    }
}
