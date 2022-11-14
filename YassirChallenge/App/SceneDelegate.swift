//
// YassirChallenge
// Created by Chetan Aggarwal.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let initialViewController = createMovieListViewController()
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Configurations
struct Configurations {
    static let imageBaseUrl: String = "http://image.tmdb.org/t/p/w92"
}

// MARK: - Movie List Controller Setup

private func createMovieListViewController() -> MovieListViewController {
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&language=en-US&sort_by=popularity.desc&include_video=false&page=1")!
    let client = URLSessionHTTPClient()
    let loader = RemoteMovieListLoader(url: url, client: client)
    let viewModel = MovieListViewModel(with: loader)
    return MovieListViewController(with: viewModel)
}

// MARK: - Create Detail View Controller

func createMovieDetailViewController(with id: UInt) -> MovieDetailViewController {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&language=en-US")!
    let client = URLSessionHTTPClient()
    let loader = RemoteMovieDetailLoader(url: url,
                                         client: client)
    let viewModel = MovieDetailViewModel(with: loader)
    return MovieDetailViewController(with: viewModel)
}
