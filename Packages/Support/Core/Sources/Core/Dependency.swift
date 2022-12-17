import Foundation

@propertyWrapper
public struct Dependency<T> {
    private var service: T?
    public var wrappedValue: T {
        mutating get {
            if let service = service {
                return service
            }
            let resolution = DependencyContainer.resolve(T.self)
            service = resolution
            return resolution
        }
        mutating set {
            service = newValue
        }
    }
    
    public init() {}
}
