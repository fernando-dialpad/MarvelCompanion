import UIKit

class MarvelCharacterDetailViewController: UIViewController {
    private var viewModel: MarvelCharacterDetailViewModel

    init(viewModel: MarvelCharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupBindings() {

    }
}
