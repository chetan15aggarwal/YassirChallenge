//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import Foundation

//MARK: - URLProtocolStub

final class URLProtocolStub: URLProtocol {
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
