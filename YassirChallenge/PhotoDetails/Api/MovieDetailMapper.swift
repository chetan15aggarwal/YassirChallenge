//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

internal final class MovieDetailMapper {
    
    private static let OK_200 = 200
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws  -> MovieDetailDTO {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard response.statusCode == OK_200,
              let details = try? decoder.decode(MovieDetailDTO.self, from: data) else {
                  throw RemoteMovieDetailLoader.Error.invalidData
        }
        return details
    }
}
