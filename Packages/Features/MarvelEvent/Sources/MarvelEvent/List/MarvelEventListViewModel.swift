import Assets
import Core
import Combine
import DataManager

final class MarvelEventListViewModel {
    var eventViewModels = CurrentValueSubject<[MarvelEventViewModel], Never>([])
    var unfilteredViewModels: [MarvelEventViewModel] = []
    @Dependency var dataManager: MarvelDataManager
    @Dependency var dataListener: MarvelDataManager

    func load() {
        Task { @MainActor in
            let events = try await dataManager.fetchMarvelEvents()
            let characters = try await dataManager.fetchMarvelCharacters()
            let viewModels = events.map { event in
                let charactersInEvent = characters.filter { event.characters.contains($0.id) }
                return MarvelEventViewModel(event: event, characters: charactersInEvent)
            }
            unfilteredViewModels = viewModels
            eventViewModels.send(viewModels)
        }
    }

    func filter(by term: String) {
        guard !term.isEmpty else {
            eventViewModels.send(unfilteredViewModels)
            return
        }
        let filteredViewModels = unfilteredViewModels.filter { viewModel in
            let event = viewModel.event.value
            let charactersNames = viewModel.charactersNames.value.string
            let titleContainsTerm = event.title.contains(term)
            let descriptionContainsTerm = event.description.contains(term)
            let avaiableComicsContainsTerm = Strings
                .numberOfComics(count: event.availableComics)
                .contains(term)
            let characterNamesContainsTerm = charactersNames.contains(term)
            return titleContainsTerm
                || descriptionContainsTerm
                || avaiableComicsContainsTerm
                || characterNamesContainsTerm
        }
        eventViewModels.send(filteredViewModels)
    }
}
