//
// YassirChallengeTests
// Created by Chetan Aggarwal.


import XCTest

extension XCTestCase {
    
    func trackMemoryLeak(_ instance: AnyObject,
                            file: StaticString = #filePath,
                                 line: UInt = #line ){
        
        // addTeardownBlock blocks run after each test
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
