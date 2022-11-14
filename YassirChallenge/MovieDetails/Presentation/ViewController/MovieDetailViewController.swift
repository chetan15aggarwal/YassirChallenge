//
// YassirChallenge
// Created by Chetan Aggarwal.

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    let viewModel: MovieDetailViewModeling!
    
    // MARK: - Initialisers
    
    init(with _viewModel: MovieDetailViewModeling) {
        self.viewModel = _viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchMovieDetails()
    }
    
    // MARK: - Helpers
    private func setupBindings() {
        bindTableViewReload()
        bindErrorHandling()
    }
    
    private func bindTableViewReload() {
        viewModel.shouldRefreshView.bind {[weak self] (movieDetails) in
            guard let self = self else { return }
            guard let details = movieDetails else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = details?.title
                self.overviewLabel.text = details?.overview
                if let averageVoteValue = details?.averageVote {
                    self.averageVoteLabel.text = "\(averageVoteValue)"
                }
                
                if let posterImagePath = details?.posterPath {
                    let url = MovieUrl.imageBaseUrl(posterImagePath).url()
                    self.movieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "moviePosterPlaceholder"), context: nil)
                }
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
        let alertController = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
