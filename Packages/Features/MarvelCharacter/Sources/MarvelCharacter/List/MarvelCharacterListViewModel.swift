import Core
import Combine
import DataManager
import SharedModels

final class MarvelCharacterListViewModel {
    var characterViewModels = CurrentValueSubject<[MarvelCharacterViewModel], Never>([])
    @Dependency var dataManager: MarvelDataManager
    @Dependency var dataListener: MarvelDataManager

    func load() {
        Task { @MainActor in
            let characters = try await dataManager.fetchMarvelCharacters()
            let viewModels = characters.map(MarvelCharacterViewModel.init(character:))
            characterViewModels.send(viewModels)
        }
    }

    func sort(segment: MarvelSortSegment) {
        var viewModels = characterViewModels.value
        switch segment {
        case .recents:
            viewModels.sort { $0.character.value.modifiedDate > $1.character.value.modifiedDate }
        case .name:
            viewModels.sort { $0.character.value.name < $1.character.value.name }
        }
        characterViewModels.send(viewModels)
    }
}
