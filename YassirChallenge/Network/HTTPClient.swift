//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

// MARK: - HTTPClient Protocol
protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void )
}
