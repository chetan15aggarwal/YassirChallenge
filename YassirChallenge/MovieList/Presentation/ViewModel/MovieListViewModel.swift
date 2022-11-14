//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

protocol MovieListViewModeling {
    var errorMessage: Container<String?> { get }
    var shouldReloadTableView: Container<Bool> { get }
    
    func fetchMovieList()
    
    func numberOfRows(in section: Int) -> Int
    func data(for indexpath: IndexPath) -> MovieListItem
    func didSelect(indexPath: IndexPath) -> MovieListItem
}

final class MovieListViewModel: MovieListViewModeling {
    let movieListLoader: MovieListLoader
    var movieList: [MovieListItem] = []
    
    var errorMessage = Container<String?>(value: nil)
    var shouldReloadTableView: Container<Bool> = Container.init(value: false)
    
    init(with _movieListLoader: MovieListLoader) {
        self.movieListLoader = _movieListLoader
    }
    
    func fetchMovieList() {
        movieListLoader.load { result in
            switch result {
            case let .success(movieList):
                self.movieList = movieList
                self.shouldReloadTableView.value = true
                
            case let .failure(error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return movieList.count
    }
    
    func data(for indexpath: IndexPath) -> MovieListItem {
        return movieList[indexpath.row]
    }
    
    func didSelect(indexPath: IndexPath) -> MovieListItem {
        return movieList[indexPath.row]
    }
    
}
