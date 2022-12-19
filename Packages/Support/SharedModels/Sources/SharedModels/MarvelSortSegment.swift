import Assets
import Foundation

public enum MarvelSortSegment: Int {
    case name
    case recents

    public var title: String {
        switch self {
        case .name: return Strings.name
        case .recents: return Strings.recents
        }
    }
}
