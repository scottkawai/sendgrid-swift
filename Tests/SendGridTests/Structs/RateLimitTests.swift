//
//  RateLimitTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/17/17.
//

import XCTest
@testable import SendGrid

class RateLimitTests: XCTestCase {
    
    func testStaticInitializer() {
        let url = URL(fileURLWithPath: "/foo")
        let headers: [String:String] = [
            "X-RateLimit-Limit": "500",
            "X-RateLimit-Remaining": "499",
            "X-RateLimit-Reset": "1466435354"
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        
        guard let info = RateLimit.from(response: response) else
        {
            XCTFail("Received `nil` from Rate limit initializer.")
            return
        }
        
        XCTAssertEqual(info.limit, 500)
        XCTAssertEqual(info.remaining, 499)
        XCTAssertEqual(info.resetDate.timeIntervalSince1970, 1466435354)
    }
    
    func testBadHeaders() {
        let url = URL(fileURLWithPath: "/foo")
        let headers: [String:String] = [
            "X-RateLimit-Limit": "foo",
            "X-RateLimit-Remaining": "bar",
            "X-RateLimit-Reset": "baz"
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        
        let info = RateLimit.from(response: response)
        XCTAssertNil(info)
    }
    
}
