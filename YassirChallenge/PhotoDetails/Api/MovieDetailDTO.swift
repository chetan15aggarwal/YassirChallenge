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
