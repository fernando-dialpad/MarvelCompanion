import Assets
import Combine
import CoreUI
import SharedModels
import UIKit

final class MarvelEventView: UIView {
    private var viewModel: MarvelEventViewModel
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
    private lazy var subContentHorizontalStackView: UIStackView = {
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
    private lazy var titleLabelView: UILabel = {
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
    private lazy var comicsLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .caption2)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var characterLinksLabelView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .black
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .subheadline)
            .withWeight(.bold)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cancellables = Set<AnyCancellable>()

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
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
        constrain(horizontalStackView, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        horizontalStackView.addArrangedSubview(mediaContainerView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(headerHorizontalStackView)
        verticalStackView.addArrangedSubview(contentHorizontalStackView)
        verticalStackView.addArrangedSubview(subContentHorizontalStackView)
        verticalStackView.addArrangedSubview(footerHorizontalStackView)
        headerHorizontalStackView.addArrangedSubview(titleLabelView)
        contentHorizontalStackView.addArrangedSubview(descriptionLabelView)
        subContentHorizontalStackView.addArrangedSubview(comicsLabelView)
        footerHorizontalStackView.addArrangedSubview(characterLinksLabelView)
        let mediaContainerAspectRatioConstraint = mediaContainerView.widthAnchor.constraint(equalTo: mediaContainerView.heightAnchor)
        mediaContainerAspectRatioConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            mediaContainerAspectRatioConstraint,
            mediaContainerView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupBindings() {
        viewModel.event
            .sink { [weak self] event in
                self?.titleLabelView.text = event.title
                self?.descriptionLabelView.text = event.description
                self?.contentHorizontalStackView.isHidden = event.description.isEmpty
                self?.comicsLabelView.text = Strings.numberOfComics(count: event.availableComics)
            }
            .store(in: &cancellables)
        viewModel.charactersNames
            .sink { [weak self] charactersNames in
                self?.characterLinksLabelView.attributedText = charactersNames
            }
            .store(in: &cancellables)
    }
}
