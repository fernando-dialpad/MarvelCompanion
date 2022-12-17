import Foundation

public struct NotifierConfig {
    let key: String
    let clientId: String
    let channel: String

    public init(environment: NotificationEnvironment) {
        guard
            let path = Bundle.module.path(forResource: environment.rawValue, ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            let environmentDict = try? PropertyListSerialization.propertyList(
                from: data,
                options: .mutableContainers,
                format: nil
            ) as? [String: String]
        else { fatalError("Environment file is missing") }
        key = environmentDict["Ably API key"] ?? ""
        clientId = environmentDict["Ably API client id"] ?? ""
        channel = environmentDict["Ably API channel"] ?? ""
    }
}
