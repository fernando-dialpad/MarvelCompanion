import Foundation

public enum MarvelFavoriteRank: Hashable, Codable {
    case notFavorited
    case favorited(rank: Int)
}
