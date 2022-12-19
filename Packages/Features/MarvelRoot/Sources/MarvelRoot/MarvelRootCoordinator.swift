import MarvelCharacter
import MarvelEvent
import MarvelFavorite
import UIKit

public final class MarvelRootCoordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController
    private var marvelCharacterCoordinator: MarvelCharacterCoordinator
    private var marvelEventCoordinator: MarvelEventCoordinator
    private var marvelFavoriteCoordinator: MarvelFavoriteCoordinator

    public init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let viewController = MarvelTabViewController(viewModel: MarvelTabViewModel())
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.isNavigationBarHidden = true
        marvelCharacterCoordinator = MarvelCharacterCoordinator(tabController: viewController.tabController)
        marvelEventCoordinator = MarvelEventCoordinator(tabController: viewController.tabController)
        marvelFavoriteCoordinator = MarvelFavoriteCoordinator(tabController: viewController.tabController)
    }

    public func start() {
        marvelCharacterCoordinator.start(animated: false)
        marvelEventCoordinator.start(animated: false)
        marvelFavoriteCoordinator.start(animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
