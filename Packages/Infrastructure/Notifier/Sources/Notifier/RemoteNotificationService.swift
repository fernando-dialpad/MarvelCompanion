import Ably
import Core

public protocol RemoteNotificationService {
    var notifications: AsyncStream<[AnyHashable: Any]> { get }
    func activate() async -> Bool
    func didRegister(deviceToken: Data)
    func didFailToRegister(error: Error)
}

public final class AblyRemoteNotificationService: NSObject, RemoteNotificationService {
    private var client: ARTRealtime?
    private var activatePushContinuation: CheckedContinuation<Bool, Never>?
    @Dependency private var config: NotifierConfig

    public override init() {
        super.init()
        let options = ARTClientOptions(key: config.key)
        options.clientId = config.clientId
        options.pushRegistererDelegate = self
        client = ARTRealtime(options: options)
    }

    public var notifications: AsyncStream<[AnyHashable: Any]> {
        AsyncStream { continuation in
            client?.channels
                .get(config.channel)
                .subscribe { message in
                    guard let data = message.data as? [String: Any] else { return }
                    continuation.yield(data)
                }
        }
    }

    public func activate() async -> Bool {
        activatePushContinuation?.resume(returning: false)
        activatePushContinuation = nil
        client?.push.activate()
        return await withCheckedContinuation { activatePushContinuation = $0 }
    }

    public func didRegister(deviceToken: Data) {
        guard let client else { return }
        ARTPush.didRegisterForRemoteNotifications(withDeviceToken: deviceToken, realtime: client)
    }

    public func didFailToRegister(error: Error) {
        guard let client else { return }
        ARTPush.didFailToRegisterForRemoteNotificationsWithError(error, realtime: client)
    }
}

extension AblyRemoteNotificationService: ARTPushRegistererDelegate {
    public func didActivateAblyPush(_ error: ARTErrorInfo?) {
        activatePushContinuation?.resume(returning: error == nil)
        activatePushContinuation = nil
    }

    public func didDeactivateAblyPush(_ error: ARTErrorInfo?) {}
}
