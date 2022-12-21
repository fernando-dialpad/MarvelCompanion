import Assets
import Core
import CoreUI
import ComposableArchitecture
import Foundation
import DataManager
import SharedModels
import ComposableArchitecture

struct MarvelCharacterReducer: ReducerProtocol {
    typealias Dependency = ComposableArchitecture.Dependency
    struct State: Equatable {
        var character: MarvelCharacter
        var characterModifiedDate: String
        var isFavoriteButtonVisible: Bool
        var isDescriptionVisible : Bool
        var isStoriesVisible : Bool
        var mediaContainerViewModel = MediaContainerViewModel(isRound: true, borderWidth: 0.5)

        init(
            character: MarvelCharacter,
            currentDate: Date = Date.now,
            isFavoriteButtonVisible: Bool = true,
            isDescriptionVisible: Bool = true,
            isStoriesVisible: Bool = true
        ) {
            self.character = character
            self.isDescriptionVisible = isDescriptionVisible && character.description.isEmpty
            self.isFavoriteButtonVisible = isFavoriteButtonVisible
            self.isDescriptionVisible = isDescriptionVisible
            self.isStoriesVisible = isStoriesVisible
            let formatter: RelativeDateTimeFormatter = .namedAbbreviated
            let relativeDateTime = formatter.localizedString(for: character.modifiedDate, relativeTo: currentDate)
            characterModifiedDate = String(format: Strings.updatedAt, relativeDateTime)
        }
    }

    enum Action: Equatable {
        enum Local: Equatable {
            case updateCharacter(character: MarvelCharacter)
        }
        case local(Local)
        case load
        case toggleFavorites
    }

    @Dependency(\.dataManager) private var dataManager

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .load: return load(state)
        case .toggleFavorites: return toggleFavorites(state)
        case let .local(.updateCharacter(character)): return updateCharacter(&state, character: character)
        }
    }

    private func load(_ state: State) -> Effect<Action, Never> {
        .run { send in
            try await state.mediaContainerViewModel.load(url: state.character.thumbnailURL)
        }
    }

    private func toggleFavorites(_ state: State) -> Effect<Action, Never> {
        .run { send in
            var favoritedCharacters = try await getFavoritedCharacters()
            let maximumRank = getMaximumRank(favoritedCharacters: favoritedCharacters)
            var character = state.character
            if character.favoriteRank == .notFavorited {
                character.favoriteRank = .favorited(rank: maximumRank + 1)
                try dataManager.saveMarvelCharacter(character: character)
            } else {
                character.favoriteRank = .notFavorited
                try dataManager.saveMarvelCharacter(character: character)
                favoritedCharacters.removeAll { $0.id == character.id }
                organizeRanks(favoritedCharacters: &favoritedCharacters)
                try dataManager.saveMarvelCharacters(characters: favoritedCharacters)
            }
            await send(.local(.updateCharacter(character: character)))
        }
    }

    private func updateCharacter(_ state: inout State, character: MarvelCharacter) -> Effect<Action, Never> {
        state.character = character
        return .none
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

public extension DependencyValues {
    enum MarvelDataManagerKey: DependencyKey {
        @Core.Dependency static var dataManager: MarvelDataManager
        public static let liveValue = dataManager
    }

    var dataManager: MarvelDataManager {
        get { self[MarvelDataManagerKey.self] }
        set { self[MarvelDataManagerKey.self] = newValue }
    }
}
