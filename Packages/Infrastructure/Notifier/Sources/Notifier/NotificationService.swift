import Core
import Foundation

public final class NotificationService {
    @Dependency var userNotificationService: UserNotificationService
    @Dependency var remoteNotificationService: RemoteNotificationService

    public init() {}

    public var pushNotifications: AsyncStream<[AnyHashable: Any]> {
        userNotificationService.notifications
    }

    public var channelNotifications: AsyncStream<[AnyHashable: Any]> {
        remoteNotificationService.notifications
    }

    public func authorized() async -> Bool {
        await userNotificationService.authorized()
    }

    public func activate() async -> Bool {
        let granted = await userNotificationService.requestAuthorization()
        guard granted else { return false }
        return await remoteNotificationService.activate()
    }
}
