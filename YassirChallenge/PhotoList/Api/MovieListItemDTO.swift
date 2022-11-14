//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

struct MovieListItemDTO: Decodable {
    let id: UInt
    let title: String
    let posterPath: String?
    let adult: Bool
    let voteAverage: Double
    let voteCount: Int
    let overview: String
    
    func toModels() -> MovieListItem {
        
        return MovieListItem(id: id, title: title, posterPath: posterPath, adult: adult, voteAverage: voteAverage, voteCount: voteCount, overview: overview)
    }
}

struct Root: Decodable {
    let page: UInt
    let results: [MovieListItemDTO]
    let totalPages: UInt
    let totalResults: UInt
}

extension Array where Element == MovieListItemDTO {
    func toModels() -> [MovieListItem] {
        return map {
            
            MovieListItem(id: $0.id, title: $0.title, posterPath: $0.posterPath, adult: $0.adult, voteAverage: $0.voteAverage, voteCount: $0.voteCount, overview: $0.overview)
        }
    }
}
