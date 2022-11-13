//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

enum LoadMovieListResult {
    case success([MovieListItem])
    case failure(Error)
}

// MARK: - MovieListLoader Protocol
protocol MovieListLoader {
    func load(completion: @escaping (LoadMovieListResult) -> Void)
}
