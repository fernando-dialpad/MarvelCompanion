import Assets
import Core
import CoreUI
import Combine
import DataManager
import Foundation
import SharedModels
import UIKit

final class MarvelEventViewModel {
    var event: CurrentValueSubject<MarvelEvent, Never>
    var charactersNames: CurrentValueSubject<NSAttributedString, Never>
    var mediaContainerViewModel = MediaContainerViewModel(isRound: true, borderWidth: 0.5)
    private var characters: [MarvelCharacter]
    @Dependency private var dataManager: MarvelDataManager
    @Dependency private var dataListener: MarvelDataListener

    init(event: MarvelEvent, characters: [MarvelCharacter]) {
        self.event = .init(event)
        self.characters = characters
        self.charactersNames = .init(Self.getCharacterNames(for: characters))
        updateFavorites()
    }

    func load() {
        mediaContainerViewModel.load(url: event.value.thumbnailURL)
    }

    private static func getCharacterNames(for characters: [MarvelCharacter]) -> NSAttributedString {
        let namesAttributed = characters.map { character in
            let nameAttributed = NSMutableAttributedString(string: character.name)
            let range = NSRange(character.name.startIndex..., in: character.name)
            nameAttributed.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            let color = character.favoriteRank == .notFavorited
                ? UIColor.main.link
                : UIColor.main.warning
            nameAttributed.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            return nameAttributed
        }
        let output = namesAttributed.reduce(into: NSMutableAttributedString()) { previous, next in
            previous.append(next)
            previous.append(NSAttributedString(", "))
        }
        if output.length >= 2 {
            output.deleteCharacters(in: NSRange(location: output.length - 2, length: 2))
        }
        return output
    }

    private func updateFavorites() {
        Task { @MainActor in
            for await updatedCharacters in dataListener.updatedCharacters {
                let updatedCharactersForThisEvent = updatedCharacters.filter { updated in characters.contains { $0.id == updated.id } }
                characters = updatedCharactersForThisEvent
                charactersNames.send(Self.getCharacterNames(for: updatedCharactersForThisEvent))
            }
        }
    }
}

extension MarvelEventViewModel: Hashable {
    static func == (lhs: MarvelEventViewModel, rhs: MarvelEventViewModel) -> Bool {
        lhs.event.value == rhs.event.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(event.value)
    }
}
