//
// YassirChallenge
// Created by Chetan Aggarwal.

import UIKit
import SDWebImage
final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var averageVoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(_ movie: MovieListItem) {
        self.averageVoteLabel.text = "Average Vote: \(movie.voteAverage)"
        self.movieNameLabel.text = movie.title
        
        if let posterImagePath = movie.posterPath {
            let url = MovieUrl.imageBaseUrl(posterImagePath).url()
            self.movieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "moviePosterPlaceholder"), context: nil)
        }
    }
}
