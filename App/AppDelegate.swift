import UIKit
import Core
import Network
import Notifier
import Storage
import SharedModels

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    @Dependency var remoteNotificationService: RemoteNotificationService

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        injectDependencies()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        remoteNotificationService.didRegister(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        remoteNotificationService.didFailToRegister(error: error)
    }

    private func injectDependencies() {
        DependencyContainer.register(NetworkConfig.self, value: NetworkConfig(environment: .defaultEnvironment))
        DependencyContainer.register(NotifierConfig.self, value: NotifierConfig(environment: .defaultEnvironment))
        DependencyContainer.register(UserNotificationService.self, value: AppleUserNotificationService())
        DependencyContainer.register(RemoteNotificationService.self, value: AblyRemoteNotificationService(), singleton: true)
        DependencyContainer.register(MarvelService.self, value: NetworkMarvelService())
        DependencyContainer.register(ImageService.self, value: NetworkImageService())
        DependencyContainer.register(MarvelStorageService.self, value: UserDefaultsMarvelStorageService())
    }
}
