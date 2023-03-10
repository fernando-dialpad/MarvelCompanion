import SharedModels
import UIKit

public class MarvelEventCoordinator {
    private weak var tabController: UITabBarController?
    private weak var navigationController: UINavigationController?

    public init(tabController: UITabBarController) {
        self.tabController = tabController
    }

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let viewController = MarvelEventListViewController(viewModel: MarvelEventListViewModel())
        if let tabController {
            let item = UITabBarItem()
            let tab = MarvelTab.events
            item.title = tab.title
            item.image = UIImage(systemName: tab.imageName)
            viewController.tabBarItem = item
            var viewControllers = tabController.viewControllers ?? []
            viewControllers.append(viewController)
            tabController.setViewControllers(viewControllers, animated: animated)
        } else if let navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
}
