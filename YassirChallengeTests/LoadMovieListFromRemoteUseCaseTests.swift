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
