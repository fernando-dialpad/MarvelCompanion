import Foundation

public protocol StorageService {
    func updatedData<T: Codable & Identifiable>(of type: T.Type) -> AsyncStream<[T]>
    func fetchAll<T: Codable & Identifiable>() throws -> [T]
    func fetch<T: Codable & Identifiable>(for id: T.ID) throws -> T?
    func save<T: Codable & Identifiable>(_ data: T) throws
    func saveAll<T: Codable & Identifiable>(_ data: [T]) throws
}

public final class UserDefaultsStorageService: StorageService {
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    public init() {}

    public func updatedData<T: Codable & Identifiable>(of type: T.Type) -> AsyncStream<[T]> {
        AsyncStream { continuation in
            Task {
                for await _ in NotificationCenter.default.notifications(named: UserDefaults.didChangeNotification) {
                    let fetched: [T] = try fetchAll()
                    continuation.yield(fetched)
                }
            }
        }
    }

    public func fetchAll<T: Codable & Identifiable>() throws -> [T] {
        let key = String(describing: T.self)
        guard let fetched = UserDefaults.standard.object(forKey: key) as? Data else {
            return []
        }
        return try decoder.decode([T].self, from: fetched)
    }

    public func fetch<T: Codable & Identifiable>(for id: T.ID) throws -> T? {
        let fetched: [T] = try fetchAll()
        return fetched.first { $0.id == id }
    }

    public func save<T: Codable & Identifiable>(_ data: T) throws {
        var fetched: [T] = try fetchAll()
        if let index = fetched.firstIndex(where: { $0.id == data.id }) {
            fetched[index] = data
        } else {
            fetched.append(data)
        }
        try saveAll(fetched)
    }

    public func saveAll<T: Codable & Identifiable>(_ data: [T]) throws {
        var fetched: [T] = try fetchAll()
        var newItems: [T] = []
        for value in data {
            if let index = fetched.firstIndex(where: { $0.id == value.id }) {
                fetched[index] = value
            } else {
                newItems.append(value)
            }
        }
        fetched.append(contentsOf: newItems)
        let encoded = try encoder.encode(data)
        let key = String(describing: T.self)
        UserDefaults.standard.set(encoded, forKey: key)
    }
}
