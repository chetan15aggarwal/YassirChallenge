//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

final class RemoteMovieDetailLoader: MovieDetailLoader {
    
    typealias Result = LoadMovieDetailResult
    
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
    func load(completion: @escaping (LoadMovieDetailResult) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(RemoteMovieDetailLoader.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let details = try MovieDetailMapper.map(data, response)
            return .success(details.toModel())
        } catch {
            return .failure(error)
        }
    }
}
