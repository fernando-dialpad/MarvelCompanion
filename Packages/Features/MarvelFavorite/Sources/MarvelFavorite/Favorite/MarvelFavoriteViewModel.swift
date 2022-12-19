import Core
import CoreUI
import Combine
import DataManager
import SharedModels

final class MarvelFavoriteViewModel: ObservableObject, Identifiable {
    var id: MarvelCharacter.ID { character.id }
    @Published var character: MarvelCharacter
    var mediaContainerViewModel = MediaContainerViewModel(isRound: true, borderWidth: 0.5)

    init(character: MarvelCharacter) {
        self.character = character
    }

    func load() {
        mediaContainerViewModel.load(url: character.thumbnailURL)
    }
}
