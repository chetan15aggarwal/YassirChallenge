//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

internal final class MovieListItemsMapper {
    
    private static let OK_200 = 200
    private struct Root: Decodable {
        let page: UInt
        let results: [MovieListItemDTO]
        let totalPages: String
        let totalResults: String
    }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws  -> [MovieListItemDTO] {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard response.statusCode == OK_200,
              let root = try? decoder.decode(Root.self, from: data) else {
                  throw RemoteMovieListLoader.Error.invalidData
        }
        return root.results
    }
}
