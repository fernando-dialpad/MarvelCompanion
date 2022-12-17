import Foundation

public protocol ImageService {
    func fetchImage(url: URL?) async throws -> Data
}

public final class NetworkImageService: ImageService {
    enum RemoteImageError: Error {
        case invalidURL
    }
    private var cache = NSCache<NSString, NSData>()

    public init() {}

    public func fetchImage(url: URL?) async throws -> Data {
        guard let url = url else { throw RemoteImageError.invalidURL }
        if let cached = cache.object(forKey: url.absoluteString as NSString) {
            return Data(referencing: cached)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
        return data
    }
}
