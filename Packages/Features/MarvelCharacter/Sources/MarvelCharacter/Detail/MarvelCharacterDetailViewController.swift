import Assets
import Combine
import Core
import CoreUI
import SharedModels
import UIKit

class MarvelCharacterDetailViewController: UIViewController {
    private var viewModel: MarvelCharacterDetailViewModel
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var toolbarHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .top
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var contentHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 32
        view.alignment = .center
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var closeButtonView: UIButton = {
        let view = UIButton()
        view.setTitle(Strings.close, for: .normal)
        view.setTitleColor(.main.accent, for: .normal)
        view.setTitleColor(.main.accent.withAlphaComponent(0.5), for: .highlighted)
        view.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        view.tintColor = .main.accent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var characterView: MarvelCharacterView = {
        let view = MarvelCharacterView(viewModel: viewModel.characterViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var rankPillView: PillView = {
        let view = PillView(viewModel: viewModel.pillViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var descriptionLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption1)
            .withTraits(traits: .traitItalic)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var eventsHeaderLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption1)
            .withWeight(.bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var eventsTitlesLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var favoriteImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "star.fill")
        view.image = image
        view.tintColor = .main.warning
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MarvelCharacterDetailViewModel) {
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
        Task { try await viewModel.load() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { try await viewModel.appear() }
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(verticalStackView)
        view.constrain(verticalStackView, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        verticalStackView.addArrangedSubview(toolbarHorizontalStackView)
        verticalStackView.addArrangedSubview(characterView)
        verticalStackView.addArrangedSubview(descriptionLabelView)
        verticalStackView.addArrangedSubview(contentHorizontalStackView)
        verticalStackView.addArrangedSubview(eventsHeaderLabel)
        verticalStackView.addArrangedSubview(eventsTitlesLabel)
        verticalStackView.addArrangedSubview(UIView())
        toolbarHorizontalStackView.addArrangedSubview(UIView())
        toolbarHorizontalStackView.addArrangedSubview(closeButtonView)
        contentHorizontalStackView.addArrangedSubview(rankPillView)
        contentHorizontalStackView.addArrangedSubview(favoriteImageView)
        contentHorizontalStackView.addArrangedSubview(UIView())
        let favoriteImageAspectRatio: Double = 11/10
        NSLayoutConstraint.activate([
            rankPillView.heightAnchor.constraint(equalToConstant: 50),
            rankPillView.widthAnchor.constraint(equalToConstant: 150),
            favoriteImageView.widthAnchor.constraint(equalTo: favoriteImageView.heightAnchor, multiplier: favoriteImageAspectRatio),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupBindings() {
        viewModel.isCloseVisible
            .sink { [weak self] isCloseVisible in
                self?.toolbarHorizontalStackView.isHidden = !isCloseVisible
            }
            .store(in: &cancellables)
        viewModel.isDescriptionVisible
            .sink { [weak self] isDescriptionVisible in
                self?.contentHorizontalStackView.isHidden = !isDescriptionVisible
            }
            .store(in: &cancellables)
        viewModel.isPillVisible
            .sink { [weak self] isPillVisible in
                self?.contentHorizontalStackView.isHidden = !isPillVisible
            }
            .store(in: &cancellables)
        viewModel.isEventsVisible
            .sink { [weak self] isEventsVisible in
                self?.eventsHeaderLabel.isHidden = !isEventsVisible
                self?.eventsTitlesLabel.isHidden = !isEventsVisible
            }
            .store(in: &cancellables)
        viewModel.eventsHeader
            .sink { [weak self] eventsHeader in
                self?.eventsHeaderLabel.text = eventsHeader
            }
            .store(in: &cancellables)
        viewModel.eventsTitles
            .sink { [weak self] eventsTitles in
                self?.eventsTitlesLabel.text = eventsTitles
            }
            .store(in: &cancellables)
        viewModel.characterViewModel.character
            .sink { [weak self] character in
                if case let .favorited(rank) = character.favoriteRank {
                    self?.viewModel.pillViewModel.text.send(String(format: Strings.rankNumber, rank))
                }
                self?.descriptionLabelView.text = character.description
            }
            .store(in: &cancellables)
    }

    @objc private func tapCloseButton() {
        viewModel.finishedDisplaying.send()
    }
}
