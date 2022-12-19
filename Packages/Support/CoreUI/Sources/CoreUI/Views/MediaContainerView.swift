import Combine
import UIKit

public final class MediaContainerView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var viewModel: MediaContainerViewModel
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(viewModel: MediaContainerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(imageView)
        constrain(imageView)
        imageView.addSubview(activityIndicator)
        imageView.constrain(activityIndicator)
    }

    private func setupBindings() {
        viewModel.imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                guard
                    let imageView = self?.imageView,
                    let viewModel = self?.viewModel,
                    let image = UIImage(data: imageData ?? Data())
                else { return }
                self?.imageView.layer.masksToBounds = !viewModel.isRound
                self?.imageView.layer.cornerRadius = imageView.frame.width / 2
                self?.imageView.clipsToBounds = viewModel.isRound
                self?.imageView.image = image
                self?.imageView.layer.borderWidth = viewModel.borderWidth
            }
            .store(in: &cancellables)
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.activityIndicator.isHidden = !isLoading
            }
            .store(in: &cancellables)
    }
}
