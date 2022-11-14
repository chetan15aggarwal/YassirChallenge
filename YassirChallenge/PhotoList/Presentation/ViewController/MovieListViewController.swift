//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - Initialisers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
