//
// YassirChallenge
// Created by Chetan Aggarwal.


import Foundation

// MARK: - MovieListItem
struct MovieListItem: Hashable {
    let id: UInt
    let title: String
    let language: String
    let posterUrl: String?
    let adult: Bool
    let averageVote: Int
    let averageCount: Int
}
