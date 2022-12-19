import Assets
import Core
import Combine
import DataManager
import Foundation
import SharedModels

final class MarvelFavoriteListViewModel: ObservableObject {
    @Published var favoriteViewModels: [MarvelFavoriteViewModel] = []
    @Dependency var dataManager: MarvelDataManager
    @Dependency var dataListener: MarvelDataManager

    func load() {
        Task { @MainActor in
            let sortedCharacters = try await dataManager.fetchMarvelCharacters()
                .filter { $0.favoriteRank != .notFavorited }
                .sorted {
                    guard
                        case let .favorited(rank1) = $0.favoriteRank,
                        case let .favorited(rank2) = $1.favoriteRank
                    else { return false }
                    return rank1 < rank2
                }
            let viewModels = sortedCharacters.map(MarvelFavoriteViewModel.init(character:))
            favoriteViewModels = viewModels
        }
    }

    func orderFavoriteRank(from: IndexSet, to: Int) {
        favoriteViewModels.move(fromOffsets: from, toOffset: to)
        var rank = 1
        for viewModel in favoriteViewModels {
            viewModel.character.favoriteRank = .favorited(rank: rank)
            rank += 1
        }
        let characters = favoriteViewModels.map(\.character)
        try? dataManager.saveMarvelCharacters(characters: characters)
    }
}
