import Core
import Combine
import DataManager
import SharedModels

final class MarvelCharacterListViewModel {
    var characterSelected = PassthroughSubject<MarvelCharacter, Never>()
    var characterViewModels = CurrentValueSubject<[MarvelCharacterViewModel], Never>([])
    @Dependency var dataManager: MarvelDataManager
    @Dependency var dataListener: MarvelDataListener

    func select(row: Int) {
        let character = characterViewModels.value[row].character.value
        characterSelected.send(character)
    }

    @MainActor
    func load() async throws {
        let characters = try await dataManager.fetchMarvelCharacters()
        let viewModels = characters.map(MarvelCharacterViewModel.init(character:))
        characterViewModels.send(viewModels)
        updateCharacters()
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

    func updateCharacters() {
        Task { @MainActor in
            for await updatedCharacters in dataListener.updatedCharacters {
                for viewModel in characterViewModels.value {
                    guard let updatedCharacter = updatedCharacters.first(where: { $0.id == viewModel.character.value.id }) else { continue }
                    viewModel.character.send(updatedCharacter)
                }
            }
        }
    }
}
