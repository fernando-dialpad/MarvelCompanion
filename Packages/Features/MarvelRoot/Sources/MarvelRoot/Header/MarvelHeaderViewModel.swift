import Core
import Combine
import DataManager

final class MarvelHeaderViewModel {
    let title = CurrentValueSubject<String, Never>("")
    let favoriteCount = CurrentValueSubject<Int, Never>(0)
    let isFavoriteVisible = CurrentValueSubject<Bool, Never>(false)
    @Dependency private var dataManager: MarvelDataManager
    @Dependency private var dataListener: MarvelDataListener

    func load() {
        Task { try await getFavorites() }
    }

    private func getFavorites() async throws {
        let favorites = try await dataManager
            .fetchMarvelCharacters()
            .filter { $0.favoriteRank != .notFavorited }
        favoriteCount.send(favorites.count)
        isFavoriteVisible.send(!favorites.isEmpty)
        for await characters in dataListener.updatedCharacters {
            let favorites = characters
                .filter { $0.favoriteRank != .notFavorited }
            favoriteCount.send(favorites.count)
            isFavoriteVisible.send(!favorites.isEmpty)
        }
    }
}
