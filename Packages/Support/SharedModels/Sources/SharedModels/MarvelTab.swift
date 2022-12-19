import Assets
import Foundation

public enum MarvelTab: Int {
    case characters
    case events
    case favorites

    public var title: String {
        switch self {
        case .characters: return Strings.characters
        case .events: return Strings.events
        case .favorites: return Strings.favorites
        }
    }

    public var imageName: String {
        switch self {
        case .characters: return "figure.martial.arts"
        case .events: return "list.bullet.clipboard.fill"
        case .favorites: return "star.fill"
        }
    }
}
