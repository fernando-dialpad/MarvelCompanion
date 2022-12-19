import Assets
import Combine
import Core
import CoreUI
import SharedModels
import UIKit

class MarvelEventListViewController: UIViewController, UITableViewDelegate {
    enum Section: CaseIterable {
        case main
    }
    private var cellIdentifier = "MarvelEventListViewControllerCell"
    private var viewModel: MarvelEventListViewModel
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var searchTextFieldView: UITextField = {
        let view = UITextField()
        view.placeholder = Strings.filterEvents
        view.backgroundColor = .main.searchBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        let placeholderPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        view.leftView = placeholderPaddingView
        view.leftViewMode = .always
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()
    private lazy var searchTextImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var searchHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .center
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.keyboardDismissMode = .interactive
        view.backgroundColor = .white
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44.0
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var dataSource: UITableViewDiffableDataSource<Section, MarvelEventViewModel>? = {
        UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, viewModel -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.set(view: MarvelEventView(viewModel: viewModel))
            return cell
        }
    }()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MarvelEventListViewModel) {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        view.addSubview(verticalStackView)
        view.constrain(verticalStackView)
        verticalStackView.addArrangedSubview(searchContainerView)
        verticalStackView.addArrangedSubview(dividerView)
        verticalStackView.addArrangedSubview(tableView)
        searchContainerView.addSubview(searchHorizontalStackView)
        searchContainerView.constrain(searchHorizontalStackView, padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        searchHorizontalStackView.addArrangedSubview(searchTextFieldView)
        searchHorizontalStackView.addArrangedSubview(searchTextImageView)
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            searchTextFieldView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupBindings() {
        viewModel
            .eventViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelEventViewModel>()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems($0, toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.eventViewModels.value[indexPath.row].load()
    }

    @objc private func textFieldDidChange() {
        viewModel.filter(by: searchTextFieldView.text ?? "")
    }
}
