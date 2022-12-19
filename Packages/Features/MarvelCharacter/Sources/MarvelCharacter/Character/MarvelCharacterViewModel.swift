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
    @Dependency private var dataManager: MarvelDataManager
    private lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    init(character: MarvelCharacter) {
        self.character = .init(character)
    }

    func numberOfStories(_ count: Int) -> String {
        Strings.numberOfStories(count: count)
    }

    func modifiedDate(_ date: Date) -> String {
        return relativeDateTimeFormatter.localizedString(for: date, relativeTo: Date.now)
    }

    func load() {
        mediaContainerViewModel.load(url: character.value.thumbnailURL)
    }

    func toggleFavorite() {
        var character = self.character.value
        character.favoriteRank = character.favoriteRank == .notFavorited
            ? .favorited(rank: 0)
            : .notFavorited
        try? dataManager.saveMarvelCharacter(character: character)
        self.character.send(character)
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
