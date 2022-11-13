//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

struct MovieListItemDTO: Decodable {
    let id: UInt
    let title: String
    let originalLanguage: String
    let posterPath: String?
    let adult: Bool
    let averageVote: Int
    let averageCount: Int
    let overview: String
    
    func toModels() -> MovieListItem {
        
        return MovieListItem(id: id, title: title, originalLanguage: originalLanguage, posterPath: posterPath, adult: adult, averageVote: averageVote, averageCount: averageCount, overview: overview)
    }
}

extension Array where Element == MovieListItemDTO {
    func toModels() -> [MovieListItem] {
        return map {
            
            MovieListItem(id: $0.id, title: $0.title, originalLanguage: $0.originalLanguage, posterPath: $0.posterPath, adult: $0.adult, averageVote: $0.averageVote, averageCount: $0.averageCount, overview: $0.overview)
        }
    }
}
