import AnyCodable
import Foundation

public struct MarvelEvent: Hashable, Codable, Identifiable {
    public var id: Int
    public var title: String
    public var description: String
    public var availableComics: Int
    public var characters: [MarvelCharacter.ID]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case availableComics
        case comics
        case characters
    }

    public init(id: Int, title: String, description: String, availableComics: Int, characters: [MarvelCharacter.ID]) {
        self.id = id
        self.title = title
        self.description = description
        self.availableComics = availableComics
        self.characters = characters
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        guard let availableComics = try container.decodeIfPresent(Int.self, forKey: .availableComics) else {
            let comicsDict = try container.decode([String: AnyCodable].self, forKey: .comics)
            let charactersDict = try container.decode([String: AnyCodable].self, forKey: .characters)
            guard let availableComics = comicsDict["available"]?.value as? Int else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not parse JSON for key comics.available"))
            }
            guard let charactersItems = charactersDict["items"]?.value as? [[String: String]] else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not parse JSON for key characters.items"))
            }
            self.availableComics = availableComics
            self.characters = charactersItems
                .compactMap { $0["resourceURI"]?.split(separator: "/").last }
                .map(String.init)
                .compactMap(Int.init)
            return
        }
        self.availableComics = availableComics
        characters = try container.decode([MarvelCharacter.ID].self, forKey: .characters)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(availableComics, forKey: .availableComics)
        try container.encode(characters, forKey: .characters)
    }
}
