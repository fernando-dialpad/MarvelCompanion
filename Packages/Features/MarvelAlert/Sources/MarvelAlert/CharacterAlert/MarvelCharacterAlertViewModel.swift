import Combine
import Core
import CoreUI
import DataManager
import Foundation
import SharedModels

final class MarvelCharacterAlertViewModel {
    var finishedDisplaying = PassthroughSubject<Void, Never>()
    var mediaContainerViewModel = MediaContainerViewModel(isRound: true, borderWidth: 0.5)
    let character: CurrentValueSubject<MarvelCharacter, Never>
    var eventsTitles = CurrentValueSubject<String, Never>("")
    @Dependency private var dataManager: MarvelDataManager

    init(character: MarvelCharacter) {
        self.character = .init(character)
    }

    func load() async throws {
        try await mediaContainerViewModel.load(url: character.value.thumbnailURL)
        let events = try await dataManager.fetchMarvelEvents()
        let eventsForCharacter = events.filter {
            character.value.events.contains($0.id)
        }
        if !eventsForCharacter.isEmpty {
            let titles = String(
                eventsForCharacter
                    .map(\.title)
                    .reduce(into: "") { $0 += "\($1), " }
                    .dropLast(2)
            )
            eventsTitles.send(titles)
        }
    }
}
