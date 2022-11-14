//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

protocol MovieDetailViewModeling {
    var errorMessage: Container<String?> { get }
    var shouldRefreshView: Container<MovieDetail?> { get }
    
    func fetchMovieDetails()
}

final class MovieDetailViewModel {
    let movieDetailLoader: MovieDetailLoader
    
    var errorMessage = Container<String?>(value: nil)
    var shouldReloadTableView : Container<MovieDetail?> = Container.init(value: nil)
    
    init(with _movieDetailLoader: MovieDetailLoader) {
        self.movieDetailLoader = _movieDetailLoader
    }
    
    func fetchMovieDetails(){
        movieDetailLoader.load { result in
            switch result {
            case let .success(movieDetail):
                self.shouldReloadTableView.value = movieDetail
            case let .failure(error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
}
