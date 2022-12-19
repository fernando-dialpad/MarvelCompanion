import UIKit
import MarvelRoot

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var rootCoordinator: MarvelRootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        rootCoordinator = MarvelRootCoordinator(windowScene: windowScene)
        rootCoordinator?.start()
    }
}
