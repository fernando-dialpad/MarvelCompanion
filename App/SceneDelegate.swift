import MarvelRoot
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: MarvelRootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        coordinator = MarvelRootCoordinator(windowScene: windowScene)
        coordinator?.start()
    }
}
