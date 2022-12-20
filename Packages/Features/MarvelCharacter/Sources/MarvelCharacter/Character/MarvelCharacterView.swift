import Assets
import Combine
import CoreUI
import SharedModels
import UIKit

final class MarvelCharacterView: UIView {
    private var viewModel: MarvelCharacterViewModel
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.alignment = .top
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mediaContainerView: MediaContainerView = {
        let view = MediaContainerView(viewModel: viewModel.mediaContainerViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var headerHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .top
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var contentHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .top
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var footerHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .top
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var nameLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .title2)
            .withWeight(.bold)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var favoriteButtonView: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        view.tintColor = .main.warning
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var storiesLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption2)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var modifiedDateLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption2)
            .withTraits(traits: .traitItalic)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: MarvelCharacterViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }

    private func setupView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
        constrain(horizontalStackView, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        horizontalStackView.addArrangedSubview(mediaContainerView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(headerHorizontalStackView)
        verticalStackView.addArrangedSubview(contentHorizontalStackView)
        verticalStackView.addArrangedSubview(footerHorizontalStackView)
        headerHorizontalStackView.addArrangedSubview(nameLabelView)
        headerHorizontalStackView.addArrangedSubview(favoriteButtonView)
        contentHorizontalStackView.addArrangedSubview(descriptionLabelView)
        footerHorizontalStackView.addArrangedSubview(storiesLabelView)
        footerHorizontalStackView.addArrangedSubview(modifiedDateLabelView)
        let mediaContainerAspectRatioConstraint = mediaContainerView.widthAnchor.constraint(equalTo: mediaContainerView.heightAnchor)
        mediaContainerAspectRatioConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            mediaContainerAspectRatioConstraint,
            mediaContainerView.widthAnchor.constraint(equalToConstant: 70),
            favoriteButtonView.widthAnchor.constraint(equalTo: favoriteButtonView.heightAnchor),
            favoriteButtonView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupBindings() {
        viewModel.character
            .sink { [weak self] character in
                self?.nameLabelView.text = character.name
                self?.descriptionLabelView.text = character.description
                self?.storiesLabelView.text = self?.viewModel.numberOfStories(character.availableStories)
                self?.modifiedDateLabelView.text = self?.viewModel.modifiedDate(character.modifiedDate)
                let favoriteImage = character.favoriteRank == .notFavorited
                    ? UIImage(systemName: "star")
                    : UIImage(systemName: "star.fill")
                self?.favoriteButtonView.setImage(favoriteImage, for: .normal)
            }
            .store(in: &cancellables)
        viewModel.isDescriptionVisible
            .sink { [weak self] isDescriptionVisible in
                self?.contentHorizontalStackView.isHidden = !isDescriptionVisible
            }
            .store(in: &cancellables)
        viewModel.isFavoriteButtonVisible
            .sink { [weak self] isFavoriteButtonVisible in
                self?.favoriteButtonView.isHidden = !isFavoriteButtonVisible
            }
            .store(in: &cancellables)
        viewModel.isStoriesVisible
            .sink { [weak self] isStoriesVisible in
                self?.storiesLabelView.isHidden = !isStoriesVisible
            }
            .store(in: &cancellables)
    }

    @objc func tapFavoriteButton() {
        Task { try await viewModel.toggleFavorite() }
    }
}
