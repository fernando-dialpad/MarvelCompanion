import MarvelCharacter
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: MarvelCharacterCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        coordinator = MarvelCharacterCoordinator(windowScene: windowScene)
        coordinator?.start(animated: false)
    }
}

