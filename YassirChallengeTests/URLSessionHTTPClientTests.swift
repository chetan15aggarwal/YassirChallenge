//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import XCTest
@testable import YassirChallenge

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGetRequestWithURL()  {
        let url = anyURL()

        let exp = expectation(description: "Wait for the expectation")
        URLProtocolStub.observeRequest() { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
         makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError()  {
        let requestedError = anyNSError()

        let receivedError = resultErrorFor(data: nil, response: nil, error: requestedError)
         
        XCTAssertEqual((receivedError as NSError?)?.domain, requestedError.domain)
        XCTAssertEqual((receivedError as NSError?)?.code, requestedError.code)

    }
    
    func test_getFromURL_failsOnAllInvalidRepresentatoinCases()  {
        XCTAssertNotNil( resultErrorFor(data: nil, response: nil, error: nil) )
        XCTAssertNotNil( resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil) )
        XCTAssertNotNil( resultErrorFor(data: anyData() , response: nil, error: nil) )
        XCTAssertNotNil( resultErrorFor(data: anyData() , response: nil, error: anyNSError()) )
        XCTAssertNotNil( resultErrorFor(data: nil , response: nonHTTPURLResponse(), error: anyNSError()) )
        XCTAssertNotNil( resultErrorFor(data: nil , response: anyHTTPURLResponse(), error: anyNSError()) )
        XCTAssertNotNil( resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()) )
        XCTAssertNotNil( resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()) )
        XCTAssertNotNil( resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil) )
    }
    
    func test_getFromURL_succeedOnHTTPURLResponseWithData()  {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedWIthEmptyDataOnHTTPURLResponseWithNilData()  {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    //MARK: - Helpers
    
    private func resultValuesFor(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                file: StaticString = #filePath,
                                 line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        
        switch result {
        case let .success(data, response):
            return (data, response)
        default:
            XCTFail("expected success got \(result) instead", file:file, line: line)
            return nil
        }
    }
    
    private func resultErrorFor(data: Data?,
                                response: URLResponse?,
                                error: Error?,
                                file: StaticString = #filePath,
                                line: UInt = #line) -> Error?{
        
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("expected failure got \(result) instead", file:file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?,
                           response: URLResponse?,
                           error: Error?,
                           file: StaticString = #filePath,
                           line: UInt = #line) -> HTTPClientResult{
        
        URLProtocolStub.stub(data: data, response: response, error: error )
        let exp = expectation(description: "Wait for completion ")
        let sut = makeSUT(file:file, line: line)
        
        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
        
    }
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackMemoryLeak(sut, file:file, line: line)
        return sut
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
    
    private func nonHTTPURLResponse()-> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse{
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil )!
    }
    
    private func anyData() -> Data{
        return Data(_ : "any data".utf8)
    }
    
    private func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 1 )
    }
}

//MARK: - URLProtocolStub

private class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    private static var stub: Stub?
    private static var requestObservers:  ((URLRequest)->Void)?
    
    static func observeRequest(observer: @escaping (URLRequest)->Void) {
        requestObservers = observer
    }
    
    static func stub(data: Data?,
                     response: URLResponse?,
                     error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }
    
    static func startInterceptingRequest(){
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequest(){
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
        requestObservers = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let requestObservers = URLProtocolStub.requestObservers {
            client?.urlProtocolDidFinishLoading(self)
            return requestObservers(request)
        }

        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
