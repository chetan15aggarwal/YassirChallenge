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

// MARK: - Movie List Controller Setup

private func createMovieListViewController() -> MovieListViewController {
    return MovieListViewController(with: createMovieListViewModel())
}

private func createMovieListViewModel() -> MovieListViewModeling {
    return MovieListViewModel(with: createMovieListLoader())
    
    func createHTTPClient() -> HTTPClient {
        return URLSessionHTTPClient()
    }
    
    func createMovieListLURL() -> URL {
        return URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&language=en-US&sort_by=popularity.desc&include_video=false&page=1")!
    }
    
    func createMovieListLoader() -> MovieListLoader {
        return RemoteMovieListLoader(url: createMovieListLURL(),
                                   client: createHTTPClient())
    }
}

struct Configurations {
    static let imageBaseUrl: String = "http://image.tmdb.org/t/p/w92"
}
