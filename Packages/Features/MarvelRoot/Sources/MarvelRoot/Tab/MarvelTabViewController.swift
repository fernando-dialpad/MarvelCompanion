import CoreUI
import SharedModels
import UIKit

final class MarvelTabViewController: UIViewController {
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    lazy var headerViewController: MarvelHeaderViewController = {
        let controller = MarvelHeaderViewController(viewModel: viewModel.headerViewModel)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    lazy var tabController: UITabBarController = {
        let controller = UITabBarController()
        controller.tabBar.barTintColor = .white
        controller.delegate = self
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    var viewModel: MarvelTabViewModel

    init(viewModel: MarvelTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(verticalStackView)
        view.constrain(verticalStackView)
        add(headerViewController, to: verticalStackView)
        add(tabController, to: verticalStackView)
    }
}

extension MarvelTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let tab = MarvelTab(rawValue: tabBarController.selectedIndex) {
            viewModel.selectTab(tab)
        }
    }
}
