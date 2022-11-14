//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

// MARK: - URLSessionHTTPClient
final class URLSessionHTTPClient: HTTPClient {
    
    // MARK: - Properties
    private let  session: URLSession
    private struct UnexpectedValuesRepresentationError: Error {}
    
    // MARK: - Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - HTTPClient implementation
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentationError()))
            }
        }.resume()
    }
}
