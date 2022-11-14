//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

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
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

