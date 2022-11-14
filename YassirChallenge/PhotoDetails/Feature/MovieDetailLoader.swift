//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

enum LoadMovieDetailResult {
    case success([MovieDetailItem])
    case failure(Error)
}

// MARK: - MovieListLoader Protocol
protocol MovieDetailLoader {
    func load(completion: @escaping (LoadMovieDetailResult) -> Void)
}
