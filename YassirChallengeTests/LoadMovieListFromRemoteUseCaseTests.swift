//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import XCTest
@testable import YassirChallenge

final class LoadMovieListFromRemoteUseCaseTests: XCTestCase {

    func test_init_deosNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load(completion: { _ in })
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice () {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load(completion: { _ in })
        sut.load(completion: { _ in })
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity) ) {
            let completionError = NSError(domain: "Test", code: 0)
            client.complete(with: completionError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemJson([])
                client.complete(withStatusCode: code, data: json, index: index)
            }
        }
    }
    
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJson = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        }
    }
    
    func test_load_deliverNoItemOn200HTTPResponseWithEmptyList() {

        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let invalidJson = makeItemJson([])
            client.complete(withStatusCode: 200, data: invalidJson)
        }
    }
    
    func test_load_diliverItemsOn200HTTPResponseWithJsonItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: 663712, title: "Terrifier 2", originalLanguage: "en", posterPath: "/b6IRp6Pl2Fsq37r9jFhGoLtaqHm.jpg", adult: false, voteAverage: 7, voteCount: 563, overview: "overview description")
        
        let item2 = makeItem(id: 505642, title: "Black Panther: Wakanda Forever", originalLanguage: "en", posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg", adult: false, voteAverage: 7.6, voteCount: 347, overview: "overview description")
        
        let items = ([item1.model, item2.model])

        
        expect(sut, toCompleteWith: .success(items)) {
            let jsonData = makeItemJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: jsonData)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "http://a-given-url.com")!,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (RemoteMovieListLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteMovieListLoader(url: url, client: client)
    
        trackMemoryLeak(sut, file: file, line: line)
        trackMemoryLeak(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func trackMemoryLeak(_ instance: AnyObject,
                                 file: StaticString = #filePath,
                                 line: UInt = #line ) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
    
    private func expect(_ sut: RemoteMovieListLoader,
                        toCompleteWith expectedResult: RemoteMovieListLoader.Result,
                        file: StaticString = #filePath,
                        line: UInt = #line,
                        when action: () -> Void ) {
        
        let exp = expectation(description: "Wait for load comletion")
        
        sut.load { receivedResults in
            switch (receivedResults, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteMovieListLoader.Error), .failure(expectedError as RemoteMovieListLoader.Error)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("expected result \(expectedResult) got \(receivedResults) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteMovieListLoader.Error) -> RemoteMovieListLoader.Result {
        return .failure(error)
    }
    
    private func makeItemJson(_ items: [[String: Any]]) -> Data {
        let itemJson = ["results": items,
                        "page": 1,
                        "total_pages":40,
                        "total_results":20] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: itemJson, options: .prettyPrinted)
    }
    
    private func makeItem(id: UInt, title: String, originalLanguage: String, posterPath: String?, adult: Bool, voteAverage: Double, voteCount: Int, overview: String) -> (model: MovieListItem, json: [String: Any]) {
        
        let item = MovieListItem(id: id, title: title, originalLanguage: originalLanguage, posterPath: posterPath, adult: adult, voteAverage: voteAverage, voteCount: voteCount, overview: overview)
        

        let json: [String: Any] = [
            "id": id,
            "title": title,
            "original_language": originalLanguage,
            "poster_path": posterPath ?? "",
            "vote_average": voteAverage,
            "vote_count": voteCount,
            "overview": overview,
            "adult": adult
        ]
        
        return (item, json)
    }
    
    // MARK: - HTTPClientSpy
    private final class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void ) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
