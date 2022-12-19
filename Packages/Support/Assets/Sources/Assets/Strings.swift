import Foundation

public struct Strings {
    public static let characters: String = NSLocalizedString("Characters", bundle: .module, comment: "")
    public static let events: String = NSLocalizedString("Events", bundle: .module, comment: "")
    public static let favorites: String = NSLocalizedString("Favorites", bundle: .module, comment: "")
    public static let name: String = NSLocalizedString("Name", bundle: .module, comment: "")
    public static let recents: String = NSLocalizedString("Recents", bundle: .module, comment: "")
    public static func numberOfStories(count: Int) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("%d stories", bundle: .module, comment: ""),
            count
        )
    }
}
