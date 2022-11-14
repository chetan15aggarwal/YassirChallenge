//
// YassirChallenge
// Created by Chetan Aggarwal.

import UIKit

final class MovieListViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - View Model
    var viewModel: MovieListViewModeling!
    
    // MARK: - Initialisers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(with _viewModel: MovieListViewModeling) {
        self.viewModel = _viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.fetchMovieList()
    }
    
    // MARK: - Helpers methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setUpUI() {
        navigationItem.title = "Movie Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        setupTableView()
        setTableConstraints()
        setupBindings()
    }
    
    private func setTableConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setupBindings() {
        bindTableViewReload()
        bindErrorHandling()
    }
    
    private func bindTableViewReload() {
        viewModel.shouldReloadTableView.bind {[weak self] (needsUpdate) in
            guard needsUpdate == true else {return}
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        }
    }
    
    private func bindErrorHandling() {
        viewModel.errorMessage.bind {[weak self] (errorMessage) in
            guard let msg = errorMessage else {
                return
            }
            DispatchQueue.main.async {
                self?.showErrorMessgae(message: msg ?? "")
            }
        }
    }
    
    private func showErrorMessgae(message: String) {
        showAlert(withTitle: "Error", andMessage: message)
    }

}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.data(for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(cellData)
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.didSelect(indexPath: indexPath)
        let detailViewController = createMovieDetailViewController(with: data.id)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
