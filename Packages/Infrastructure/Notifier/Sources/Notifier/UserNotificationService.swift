import UserNotifications

public protocol UserNotificationService {
    var notifications: AsyncStream<[AnyHashable: Any]> { get }
    func requestAuthorization() async -> Bool
    func authorized() async -> Bool
}

public final class AppleUserNotificationService: NSObject, UserNotificationService {
    var notificationsContinuation: AsyncStream<[AnyHashable : Any]>.Continuation?

    public override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    public var notifications: AsyncStream<[AnyHashable: Any]> {
        notificationsContinuation?.finish()
        notificationsContinuation = nil
        return AsyncStream { notificationsContinuation = $0 }
    }

    public func authorized() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    public func requestAuthorization() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])) ?? false
    }
}

extension AppleUserNotificationService: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        notificationsContinuation?.yield(response.notification.request.content.userInfo)
        completionHandler()
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        notificationsContinuation?.yield(notification.request.content.userInfo)
        completionHandler([.badge, .banner, .sound])
    }
}
