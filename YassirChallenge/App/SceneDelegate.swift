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
    return MovieListViewController()
}
