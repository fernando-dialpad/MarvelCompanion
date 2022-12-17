import Foundation
import SharedModels

public struct NetworkEndpoints {
    public struct Characters {
        private let characterByIdFormat: String
        private let charactersFormat: String

        public init(characterByIdFormat: String, charactersFormat: String) {
            self.characterByIdFormat = characterByIdFormat
            self.charactersFormat = charactersFormat
        }

        public func characterURL(for id: MarvelCharacter.ID) -> URL {
            guard let url = URL(string: String(format: characterByIdFormat, id)) else { fatalError("Invalid configuration") }
            return url
        }

        public func charactersURL() -> URL {
            guard let url = URL(string: charactersFormat) else { fatalError("Invalid configuration") }
            return url
        }
    }

    public struct Events {
        private let eventsFormat: String

        public init(eventsFormat: String) {
            self.eventsFormat = eventsFormat
        }

        public func eventsURL() -> URL {
            guard let url = URL(string: eventsFormat) else { fatalError("Invalid configuration") }
            return url
        }
    }
    public let characters: Characters
    public let events: Events
}
