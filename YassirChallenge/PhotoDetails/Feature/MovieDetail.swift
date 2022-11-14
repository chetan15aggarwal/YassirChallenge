//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

// MARK: - MovieListItem
struct MovieDetail: Hashable {
    let id: UInt
    let title: String
    let posterPath: String?
    let overview: String
    let averageVote: Double
}
