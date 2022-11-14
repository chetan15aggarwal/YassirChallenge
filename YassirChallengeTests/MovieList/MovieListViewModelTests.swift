//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import XCTest
@testable import YassirChallenge

final class MovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var mockMovieListLoader: MockMovieListLoader!
    var mockMovieListErrorLoader: MockMovieListErrorLoader!
    
    override func setUp() {
        super.setUp()
        mockMovieListLoader = MockMovieListLoader()
        mockMovieListErrorLoader = MockMovieListErrorLoader()
    }
    
    override func tearDown() {
        sut = nil
        mockMovieListLoader = nil
        mockMovieListErrorLoader = nil
        super.tearDown()
    }
    
    
    func test_fetch_Data() {
        sut = MovieListViewModel(with: mockMovieListLoader)
        sut.fetchMovieList()
            XCTAssertTrue(mockMovieListLoader!.isloadCalled)
        }
    
    func test_create_view_model_array() {
        sut = MovieListViewModel(with: mockMovieListLoader)
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.shouldReloadTableView.bind(withHandler: { shouldReload in
            expect.fulfill()
        })
        
        sut.fetchMovieList()
        
        XCTAssertEqual( sut.movieList.count, 2)
        wait(for: [expect], timeout: 1.0)
    }

    func test_fail_create_view_model_array() {
        sut = MovieListViewModel(with: mockMovieListErrorLoader)
        let expect = XCTestExpectation(description: "error message closure triggered")
        sut.errorMessage.bind { error in
            expect.fulfill()
        }

        sut.fetchMovieList()
        
        XCTAssertEqual( sut.movieList.count, 0)
        wait(for: [expect], timeout: 1.0)
    }
}


class MockMovieListLoader: MovieListLoader {

    var isloadCalled = false
    
    func load(completion: @escaping (YassirChallenge.LoadMovieListResult) -> Void) {
        isloadCalled = true
        let data = StubGenerator().stubAcronyms("MovieListMock")
        completion(.success(data.toModels()))
    }
}

class MockMovieListErrorLoader: MovieListLoader {

    var isloadCalled = false

    func load(completion: @escaping (YassirChallenge.LoadMovieListResult) -> Void) {
        isloadCalled = true
        let error: NSError = NSError(domain: "Something went wrong", code: 404, userInfo: nil)
        completion(.failure(error))
    }
}

