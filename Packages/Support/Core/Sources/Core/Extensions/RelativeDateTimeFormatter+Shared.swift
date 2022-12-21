import Foundation

public extension RelativeDateTimeFormatter {
    static var namedAbbreviated: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .abbreviated
        return formatter
    }
}
