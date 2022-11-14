//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import Foundation
@testable import YassirChallenge

class StubGenerator {
    func stubAcronyms(_ filename: String) -> [MovieListItemDTO] {
        let path = Bundle.main.path(forResource: filename, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    
        let root = try! decoder.decode(Root.self, from: data)
        return root.results
    }
}
