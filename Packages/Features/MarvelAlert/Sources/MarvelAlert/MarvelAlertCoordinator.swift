import Combine
import Core
import DataManager
import SharedModels
import UIKit

public class MarvelAlertCoordinator {
    public let finishedDisplaying = PassthroughSubject<Void, Never>()
    private weak var navigationController: UINavigationController?
    private var cancellables = Set<AnyCancellable>()

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(character: MarvelCharacter) {
        let viewModel = MarvelCharacterAlertViewModel(character: character)
        let viewController = MarvelCharacterAlertViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: false)
        setupNavigationBindings(viewModel: viewModel)
    }

    private func setupNavigationBindings(viewModel: MarvelCharacterAlertViewModel) {
        viewModel
            .finishedDisplaying
            .sink { [weak self] in
                self?.finishedDisplaying.send()
            }
            .store(in: &cancellables)
    }
}
