import Combine
import Core
import DataManager
import SharedModels
import UIKit

public class MarvelCharacterCoordinator {
    private var window: UIWindow?
    private weak var tabController: UITabBarController?
    private weak var navigationController: UINavigationController?
    @Dependency var dataManager: MarvelDataManager
    private var cancellables = Set<AnyCancellable>()

    public init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
    }

    public init(tabController: UITabBarController) {
        self.tabController = tabController
    }

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let viewModel = MarvelCharacterListViewModel()
        let viewController = MarvelCharacterListViewController(viewModel: viewModel)
        if let tabController {
            let item = UITabBarItem()
            let tab = MarvelTab.characters
            item.title = tab.title
            item.image = UIImage(systemName: tab.imageName)
            viewController.tabBarItem = item
            var viewControllers = tabController.viewControllers ?? []
            viewControllers.append(viewController)
            tabController.setViewControllers(viewControllers, animated: animated)
        } else if let navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else if let window {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        setupNavigationBindings(viewModel: viewModel)
    }

    private func setupNavigationBindings(viewModel: MarvelCharacterListViewModel) {
        viewModel
            .characterSelected
            .sink { [weak self] character in
                let characterViewModel = MarvelCharacterViewModel(character: character)
                let viewModel = MarvelCharacterDetailViewModel(characterViewModel: characterViewModel)
                let viewController = MarvelCharacterDetailViewController(viewModel: viewModel)
                if let tabController = self?.tabController {
                    tabController.present(viewController, animated: true)
                } else if let navigationController = self?.navigationController {
                    navigationController.present(viewController, animated: true)
                } else if let window = self?.window {
                    window.rootViewController?.present(viewController, animated: true)
                }
                self?.setupDetailNavigationBindings(viewModel: viewModel)
            }
            .store(in: &cancellables)
    }

    private func setupDetailNavigationBindings(viewModel: MarvelCharacterDetailViewModel) {
        viewModel
            .finishedDisplaying
            .sink { [weak self] in
                if let tabController = self?.tabController {
                    tabController.dismiss(animated: true)
                } else if let navigationController = self?.navigationController {
                    navigationController.dismiss(animated: true)
                } else if let window = self?.window {
                    window.rootViewController?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
