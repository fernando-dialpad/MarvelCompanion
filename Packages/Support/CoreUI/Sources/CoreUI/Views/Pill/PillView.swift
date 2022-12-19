import Combine
import UIKit

public final class PillView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var labelView: UILabel = {
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
    private var viewModel: PillViewModel
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(viewModel: PillViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupBindings()
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(containerView)
        constrain(containerView)
        containerView.addSubview(labelView)
        containerView.constrain(labelView, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }

    private func setupBindings() {
        viewModel.backgroundColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                self?.containerView.backgroundColor = color
            }
            .store(in: &cancellables)
        viewModel.foregroundColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                self?.labelView.textColor = color
            }
            .store(in: &cancellables)
        viewModel.cornerRadius
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cornerRadius in
                self?.containerView.layer.cornerRadius = cornerRadius
            }
            .store(in: &cancellables)
        viewModel.text
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.labelView.text = text
            }
            .store(in: &cancellables)
    }
}
