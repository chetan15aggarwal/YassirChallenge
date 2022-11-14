//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

class MovieListViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
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
        view.backgroundColor = .green
        setupTableView()
        viewModel.fetchMovieList()
    }
    
    //MARK: - Helpers methods
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        //setup cell
        
        setTableConstraints()
    }
    
    private func setTableConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
