import SharedModels
import SwiftUI
import UIKit

public class MarvelFavoriteCoordinator {
    private weak var tabController: UITabBarController?
    private weak var navigationController: UINavigationController?

    public init(tabController: UITabBarController) {
        self.tabController = tabController
    }

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let viewController = UIHostingController(rootView: MarvelFavoriteListView(viewModel: MarvelFavoriteListViewModel()))
        if let tabController {
            let item = UITabBarItem()
            let tab = MarvelTab.favorites
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
