//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

struct MovieDetailDTO: Decodable {
    let id: UInt
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let overview: String
    
    func toModel() -> MovieDetail {
        return MovieDetail(id: id, title: title, posterPath: posterPath, overview: overview, averageVote: voteAverage)
    }
}

//extension Array where Element == MovieDetailDTO {
//    func toModel() -> MovieDetail {
//        return map {
//            MovieDetail(id: $0.id, title: $0.title, posterPath: $0.posterPath, overview: $0.overview, averageVote: $0.voteAverage)
//        }
//    }
//}
