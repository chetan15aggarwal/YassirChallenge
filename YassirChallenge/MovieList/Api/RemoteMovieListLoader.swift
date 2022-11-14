//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

final class RemoteMovieListLoader: MovieListLoader {
    
    typealias Result = LoadMovieListResult
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    // MARK: - Properties and Initialiser
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    // MARK: - VehicleLoader
    func load(completion: @escaping (LoadMovieListResult) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(RemoteMovieListLoader.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let items = try MovieListItemsMapper.map(data, response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}
