import Foundation

public struct Strings {
    public static let characters: String = NSLocalizedString("Characters", bundle: .module, comment: "")
    public static let events: String = NSLocalizedString("Events", bundle: .module, comment: "")
    public static let favorites: String = NSLocalizedString("Favorites", bundle: .module, comment: "")
    public static let name: String = NSLocalizedString("Name", bundle: .module, comment: "")
    public static let recents: String = NSLocalizedString("Recents", bundle: .module, comment: "")
    public static let filterEvents: String = NSLocalizedString("Filter Events", bundle: .module, comment: "")
    public static let thankYouMessage: String = NSLocalizedString("Thank you!\nbut your hero is in another castle", bundle: .module, comment: "")
    public static let updatedAt: String = NSLocalizedString("updated %@", bundle: .module, comment: "")
    public static let close: String = NSLocalizedString("Close", bundle: .module, comment: "")
    public static let rankNumber: String = NSLocalizedString("Rank: #%d", bundle: .module, comment: "")
    public static let eventsNumber: String = NSLocalizedString("Events(%d)", bundle: .module, comment: "")
    public static let incoming: String = NSLocalizedString("INCOMING", bundle: .module, comment: "")
    public static func numberOfStories(count: Int) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("%d stories", bundle: .module, comment: ""),
            count
        )
    }
    public static func numberOfComics(count: Int) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("%d comics", bundle: .module, comment: ""),
            count
        )
    }
}
