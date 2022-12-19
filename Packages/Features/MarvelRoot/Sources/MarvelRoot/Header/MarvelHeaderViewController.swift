import Combine
import CoreUI
import UIKit

class MarvelHeaderViewController: UIViewController {
    private var viewModel: MarvelHeaderViewModel
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .firstBaseline
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .title2)
            .withWeight(.bold)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var favoriteImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "star.fill")
        view.image = image
        view.tintColor = .main.warning
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var favoriteLabelView: UILabel = {
        let view = UILabel()
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .main.warning
        view.font = .preferredFont(forTextStyle: .body)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MarvelHeaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(horizontalStackView)
        view.constrain(horizontalStackView, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        horizontalStackView.addArrangedSubview(titleLabelView)
        horizontalStackView.addArrangedSubview(favoriteLabelView)
        horizontalStackView.addArrangedSubview(favoriteImageView)
        NSLayoutConstraint.activate([
            favoriteImageView.widthAnchor.constraint(equalTo: favoriteImageView.heightAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupBindings() {
        viewModel.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabelView.text = title
            }
            .store(in: &cancellables)
        viewModel.favoriteCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.favoriteLabelView.text = "\(count)"
            }
            .store(in: &cancellables)
        viewModel.isFavoriteVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.favoriteLabelView.isHidden = !isVisible
                self?.favoriteImageView.isHidden = !isVisible
            }
            .store(in: &cancellables)
    }
}
