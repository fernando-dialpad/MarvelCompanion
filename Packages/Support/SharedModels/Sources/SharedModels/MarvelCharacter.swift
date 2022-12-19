import AnyCodable
import Foundation

public struct MarvelCharacter: Hashable, Codable, Identifiable {
    public var id: Int
    public var name: String
    public var description: String
    public var thumbnailURL: URL
    public var availableStories: Int
    public var modifiedDate: Date
    public var events: [MarvelEvent.ID]
    public var favoriteRank: MarvelFavoriteRank

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnailURL = "thumbnail"
        case availableStories
        case modifiedDate = "modified"
        case events
        case stories
        case favoriteRank
    }

    public init(
        id: Int,
        name: String,
        description: String,
        thumbnailURL: URL,
        availableStories: Int,
        modifiedDate: Date,
        events: [MarvelEvent.ID],
        favoriteRank: MarvelFavoriteRank
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.availableStories = availableStories
        self.modifiedDate = modifiedDate
        self.events = events
        self.favoriteRank = favoriteRank
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        modifiedDate = try container.decode(Date.self, forKey: .modifiedDate)
        guard let favoriteRank = try container.decodeIfPresent(MarvelFavoriteRank.self, forKey: .favoriteRank) else {
            self.favoriteRank = .notFavorited
            let thumnailDict = try container.decode([String: AnyCodable].self, forKey: .thumbnailURL)
            let storiesDict = try container.decode([String: AnyCodable].self, forKey: .stories)
            let eventsDict = try container.decode([String: AnyCodable].self, forKey: .events)
            guard
                let thumbnailPath = thumnailDict["path"]?.value as? String,
                let thumbnailExtension = thumnailDict["extension"]?.value as? String,
                let thumbnailURL = URL(string: "\(thumbnailPath).\(thumbnailExtension)") else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not parse JSON for key thumbnail.path and thumbnail.extension"))
            }
            guard let availableStories = storiesDict["available"]?.value as? Int else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not parse JSON for key stories.available"))
            }
            guard let eventsItems = eventsDict["items"]?.value as? [[String: String]] else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not parse JSON for key events.items"))
            }
            self.thumbnailURL = thumbnailURL
            self.availableStories = availableStories
            self.events = eventsItems
                .compactMap { $0["resourceURI"]?.split(separator: "/").last }
                .map(String.init)
                .compactMap(Int.init)
            return
        }
        self.favoriteRank = favoriteRank
        thumbnailURL = try container.decode(URL.self, forKey: .thumbnailURL)
        availableStories = try container.decode(Int.self, forKey: .availableStories)
        events = try container.decode([MarvelEvent.ID].self, forKey: .events)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        try container.encode(availableStories, forKey: .availableStories)
        try container.encode(modifiedDate, forKey: .modifiedDate)
        try container.encode(events, forKey: .events)
        try container.encode(favoriteRank, forKey: .favoriteRank)
    }
}
