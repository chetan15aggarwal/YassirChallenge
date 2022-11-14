//
// YassirChallenge
// Created by Chetan Aggarwal.


import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var averageVoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(_ movie: MovieListItem) {
        self.averageVoteLabel.text = "Average Vote: \(movie.voteAverage)"
        self.movieNameLabel.text = movie.title
        self.movieImageView.image = UIImage(named: "DefaultPoster")
    }
}
