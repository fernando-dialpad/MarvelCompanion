import Assets
import Combine
import Core
import CoreUI
import SharedModels
import UIKit

class MarvelCharacterListViewController: UIViewController, UITableViewDelegate {
    enum Section: CaseIterable {
        case main
    }
    private var cellIdentifier = "MarvelCharacterListViewControllerCell"
    private var viewModel: MarvelCharacterListViewModel
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var segmentedControlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [
            MarvelSortSegment.name.title,
            MarvelSortSegment.recents.title,
        ])
        view.addTarget(self, action: #selector(segmentControlChange), for: .valueChanged)
        view.selectedSegmentIndex = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44.0
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var dataSource: UITableViewDiffableDataSource<Section, MarvelCharacterViewModel>? = {
        UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, viewModel -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            cell.set(view: MarvelCharacterView(viewModel: viewModel))
            return cell
        }
    }()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MarvelCharacterListViewModel) {
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
        verticalStackView.addArrangedSubview(segmentedControlContainer)
        verticalStackView.addArrangedSubview(dividerView)
        verticalStackView.addArrangedSubview(tableView)
        segmentedControlContainer.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            segmentedControlContainer.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -8),
            segmentedControlContainer.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainer.centerYAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainer.centerXAnchor)
        ])
    }

    private func setupBindings() {
        viewModel
            .characterViewModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacterViewModel>()
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems($0, toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.characterViewModels.value[indexPath.row].load()
    }

    @objc func segmentControlChange() {
        guard let segment = MarvelSortSegment(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.sort(segment: segment)
    }
}