//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

class MovieListViewController: UIViewController {
    
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
        viewModel.fetchMovieList()
    }
}
