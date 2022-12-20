import Combine
import MarvelCharacter
import MarvelEvent
import MarvelFavorite
import MarvelAlert
import UIKit

public final class MarvelRootCoordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController
    private var marvelCharacterCoordinator: MarvelCharacterCoordinator
    private var marvelEventCoordinator: MarvelEventCoordinator
    private var marvelFavoriteCoordinator: MarvelFavoriteCoordinator
    private var marvelAlertCoordinator: MarvelAlertCoordinator
    private var cancellables = Set<AnyCancellable>()

    public init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        let viewModel = MarvelTabViewModel()
        let viewController = MarvelTabViewController(viewModel: viewModel)
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController.isNavigationBarHidden = true
        marvelCharacterCoordinator = MarvelCharacterCoordinator(tabController: viewController.tabController)
        marvelEventCoordinator = MarvelEventCoordinator(tabController: viewController.tabController)
        marvelFavoriteCoordinator = MarvelFavoriteCoordinator(tabController: viewController.tabController)
        marvelAlertCoordinator = MarvelAlertCoordinator(navigationController: navigationController)
        setupNavigationBindings(viewModel: viewModel)
    }

    public func start() {
        marvelCharacterCoordinator.start(animated: false)
        marvelEventCoordinator.start(animated: false)
        marvelFavoriteCoordinator.start(animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func setupNavigationBindings(viewModel: MarvelTabViewModel) {
        viewModel
            .characterNotified
            .sink { [weak self] character in
                self?.marvelAlertCoordinator.start(character: character)
            }
            .store(in: &cancellables)
        marvelAlertCoordinator
            .finishedDisplaying
            .sink { [weak self] in
                self?.navigationController.dismiss(animated: false)
            }
            .store(in: &cancellables)
    }
}
