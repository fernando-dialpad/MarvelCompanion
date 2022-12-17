import Foundation

public final class DependencyContainer {
    private static var registry: [String: Any] = [:]
    
    public static func register<T>(_ type: T.Type, value: @autoclosure @escaping () -> T, singleton: Bool = false) {
        let key = String(describing: type)
        if singleton {
            registry[key] = value
        } else {
            registry[key] = value()
        }
    }
    
    public static func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let resolution = registry[key] as? () -> T {
            return resolution()
        } else if let resolution = registry[key] as?  T {
            return resolution
        } else {
            fatalError("Missing register dependency \(key)")
        }
    }
    
    public static func unregisterAll() {
        registry = [:]
    }
}
