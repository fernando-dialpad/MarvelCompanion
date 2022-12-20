import Assets
import Core
import CoreUI
import Combine
import DataManager
import Foundation
import SharedModels

final class MarvelCharacterViewModel {
    var character: CurrentValueSubject<MarvelCharacter, Never>
    var mediaContainerViewModel = MediaContainerViewModel(isRound: true, borderWidth: 0.5)
    var isFavoriteButtonVisible = CurrentValueSubject<Bool, Never>(true)
    var isDescriptionVisible = CurrentValueSubject<Bool, Never>(true)
    var isStoriesVisible = CurrentValueSubject<Bool, Never>(true)
    var modifiedDatePrefix = "%@"
    @Dependency private var dataManager: MarvelDataManager
    private lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    init(character: MarvelCharacter) {
        self.character = .init(character)
        if character.description.isEmpty {
            isDescriptionVisible.send(false)
        }
    }

    func numberOfStories(_ count: Int) -> String {
        Strings.numberOfStories(count: count)
    }

    func modifiedDate(_ date: Date) -> String {
        let relativeDateTime = relativeDateTimeFormatter.localizedString(for: date, relativeTo: Date.now)
        return String(format: modifiedDatePrefix, relativeDateTime)
    }

    func load() {
        mediaContainerViewModel.load(url: character.value.thumbnailURL)
    }

    @MainActor
    func toggleFavorite() async throws {
        var favoritedCharacters = try await getFavoritedCharacters()
        let maximumRank = getMaximumRank(favoritedCharacters: favoritedCharacters)
        var character = self.character.value
        if character.favoriteRank == .notFavorited {
            character.favoriteRank = .favorited(rank: maximumRank + 1)
            try? dataManager.saveMarvelCharacter(character: character)
        } else {
            character.favoriteRank = .notFavorited
            try? dataManager.saveMarvelCharacter(character: character)
            favoritedCharacters.removeAll { $0.id == character.id }
            organizeRanks(favoritedCharacters: &favoritedCharacters)
            try? dataManager.saveMarvelCharacters(characters: favoritedCharacters)
        }
        self.character.send(character)
    }

    private func getFavoritedCharacters() async throws-> [MarvelCharacter] {
        try await dataManager.fetchMarvelCharacters()
            .filter { $0.favoriteRank != .notFavorited }
            .sorted {
                if case let .favorited(rank1) = $0.favoriteRank, case let .favorited(rank2) = $1.favoriteRank {
                    return rank1 < rank2
                }
                return false
            }
    }

    private func getMaximumRank(favoritedCharacters: [MarvelCharacter]) -> Int {
        favoritedCharacters
            .map {
                if case let .favorited(rank) = $0.favoriteRank {
                    return rank
                } else {
                    return 0
                }
            }
            .max() ?? 0
    }

    private func organizeRanks(favoritedCharacters: inout [MarvelCharacter]) {
        var rank = 1
        for index in favoritedCharacters.indices {
            favoritedCharacters[index].favoriteRank = .favorited(rank: rank)
            rank += 1
        }
    }
}

extension MarvelCharacterViewModel: Hashable {
    static func == (lhs: MarvelCharacterViewModel, rhs: MarvelCharacterViewModel) -> Bool {
        lhs.character.value == rhs.character.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(character.value)
    }
}
