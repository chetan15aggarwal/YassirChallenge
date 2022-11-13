//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

// MARK: - MovieListItem
struct MovieListItem: Hashable {
    let id: UInt
    let title: String
    let originalLanguage: String
    let posterPath: String?
    let adult: Bool
    let averageVote: Int
    let averageCount: Int
    let overview: String
}
