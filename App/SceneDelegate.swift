import AsyncAlgorithms
import Core
import Network
import Notifier
import Storage
import SharedModels
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MyViewController()
        window?.makeKeyAndVisible()
//        let service = DependencyContainer.resolve(MarvelRestService.self)
//        let storage = DependencyContainer.resolve(MarvelStorageService.self)
//
//        Task {
//            let characters = try await service.fetchMarvelCharacters()
//            let events = try await service.fetchMarvelEvents()
//            print(characters)
//            print(events)
//            try storage.saveMarvelCharacters(characters: characters)
//            try storage.saveMarvelEvents(events: events)
//
//            let localCharacters = try storage.fetchMarvelCharacters()
//            let localEvents = try storage.fetchMarvelEvents()
//            let localCharacter = try storage.fetchMarvelCharacter(for: 1011334)
//        }
    }
}

final class MyViewController: UIViewController {
    let notificationService = NotificationService()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func tap() {
        Task {
            let isActive = await notificationService.activate()
            if isActive {
                for await notification in notificationService.channelNotifications {
                    print(notification)
                }
            }
        }
    }
}

