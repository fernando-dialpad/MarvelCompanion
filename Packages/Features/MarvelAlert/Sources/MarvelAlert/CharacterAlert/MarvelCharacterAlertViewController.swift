import Assets
import Combine
import CoreUI
import UIKit

final class MarvelCharacterAlertViewController: UIViewController {
    private let viewModel: MarvelCharacterAlertViewModel
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
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
        view.alignment = .center
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var contentHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
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
    private lazy var titleLabelView: UILabel = {
        let view = UILabel()
        view.text = "🚨 \(Strings.incoming) 🚨"
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .title3)
            .withWeight(.bold)
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var eventsLabelView: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .title3)
            .withTraits(traits: .traitItalic)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var mediaContainerView: MediaContainerView = {
        let view = MediaContainerView(viewModel: viewModel.mediaContainerViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MarvelCharacterAlertViewModel) {
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

    private func setupView() {
        view.backgroundColor = .main.accent.withAlphaComponent(0.3)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 325),
            containerView.heightAnchor.constraint(equalToConstant: 700)
        ])
        containerView.addSubview(verticalStackView)
        containerView.constrain(verticalStackView, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        verticalStackView.addArrangedSubview(toolbarHorizontalStackView)
        verticalStackView.addArrangedSubview(contentHorizontalStackView)
        verticalStackView.addArrangedSubview(eventsLabelView)
        verticalStackView.addArrangedSubview(UIView())
        let spacerView = UIView()
        toolbarHorizontalStackView.addArrangedSubview(spacerView)
        toolbarHorizontalStackView.addArrangedSubview(titleLabelView)
        toolbarHorizontalStackView.addArrangedSubview(closeButtonView)
        NSLayoutConstraint.activate([
            spacerView.widthAnchor.constraint(equalTo: closeButtonView.widthAnchor),
            mediaContainerView.widthAnchor.constraint(equalTo: mediaContainerView.heightAnchor),
            mediaContainerView.widthAnchor.constraint(equalToConstant: 70)
        ])
        contentHorizontalStackView.addArrangedSubview(mediaContainerView)
        contentHorizontalStackView.addArrangedSubview(nameLabelView)
    }

    private func setupBindings() {
        viewModel.character
            .receive(on: DispatchQueue.main)
            .sink { [weak self] character in
                self?.nameLabelView.text = character.name
            }
            .store(in: &cancellables)
        viewModel.eventsTitles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] eventsTitles in
                self?.eventsLabelView.text = eventsTitles
            }
            .store(in: &cancellables)
    }

    @objc private func tapCloseButton() {
        viewModel.finishedDisplaying.send()
    }
}
