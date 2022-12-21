import Assets
import Core
import CoreUI
import Combine
import DataManager
import SharedModels

final class MarvelCharacterDetailViewModel {
    var finishedDisplaying = PassthroughSubject<Void, Never>()
    var characterViewModel: MarvelCharacterViewModel
    var pillViewModel: PillViewModel
    var isPillVisible = CurrentValueSubject<Bool, Never>(true)
    var isCloseVisible = CurrentValueSubject<Bool, Never>(true)
    var isDescriptionVisible = CurrentValueSubject<Bool, Never>(true)
    var isEventsVisible = CurrentValueSubject<Bool, Never>(false)
    var eventsHeader = CurrentValueSubject<String, Never>("")
    var eventsTitles = CurrentValueSubject<String, Never>("")

    @Dependency private var dataManager: MarvelDataManager

    init(character: MarvelCharacter) {
        pillViewModel = PillViewModel(
            backgroundColor: .main.link,
            foregroundColor: .black,
            font: .preferredFont(forTextStyle: .title3)
                .withTraits(traits: .traitItalic),
            cornerRadius: 25,
            text: ""
        )
        characterViewModel = MarvelCharacterViewModel(character: character)
        characterViewModel.isDescriptionVisible.send(false)
        characterViewModel.isFavoriteButtonVisible.send(false)
        characterViewModel.isStoriesVisible.send(false)
        isDescriptionVisible.send(!characterViewModel.character.value.description.isEmpty)
        isPillVisible.send(characterViewModel.character.value.favoriteRank != .notFavorited)
    }

    func load() async throws {
        let events = try await dataManager.fetchMarvelEvents()
        let eventsForCharacter = events.filter {
            characterViewModel.character.value.events.contains($0.id)
        }
        isEventsVisible.send(!eventsForCharacter.isEmpty)
        if !eventsForCharacter.isEmpty {
            eventsHeader.send(String(format: Strings.eventsNumber, eventsForCharacter.count))
            let titles = String(
                eventsForCharacter
                    .map(\.title)
                    .reduce(into: "") { $0 += "\($1), " }
                    .dropLast(2)
            )
            eventsTitles.send(titles)
        }
    }

    func appear() async throws {
        try await characterViewModel.load()
    }
}
