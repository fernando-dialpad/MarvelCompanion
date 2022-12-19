import UIKit

final class MarvelEventView: UIView {
    private var viewModel: MarvelEventViewModel?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: MarvelEventViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }

    private func setupView() {
        backgroundColor = .white
    }

    private func setupBindings() {

    }
}
