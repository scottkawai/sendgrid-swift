//
//  PaginationTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class PaginationTests: XCTestCase {
    
    func testStaticInitializer() {
        let url = URL(fileURLWithPath: "/foo")
        let sample = """
        <https://api.sendgrid.com/v3/suppression/bounces?limit=500&offset=1500>; rel="next"; title="2", <https://api.sendgrid.com/v3/suppression/bounces?limit=500&offset=500>; rel="prev"; title="1", <https://api.sendgrid.com/v3/suppression/bounces?limit=500&offset=58000>; rel="last"; title="117", <https://api.sendgrid.com/v3/suppression/bounces?limit=500&offset=0>; rel="first"; title="1"
        """
        let headers: [String:String] = [
            "Link": sample
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        
        guard let pages = Pagination.from(response: response) else
        {
            XCTFail("Received `nil` from Pagination initializer.")
            return
        }
        
        XCTAssertEqual(pages.first, Page(limit: 500, offset: 0))
        XCTAssertEqual(pages.previous, Page(limit: 500, offset: 500))
        XCTAssertEqual(pages.next, Page(limit: 500, offset: 1500))
        XCTAssertEqual(pages.last, Page(limit: 500, offset: 58000))
    }
    
    func testNoHeader() {
        let url = URL(fileURLWithPath: "/foo")
        let headers: [String:String] = [
            "Foo": "Bar"
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        let pages = Pagination.from(response: response)
        XCTAssertNil(pages)
    }
    
    func testBadHeaders() {
        let url = URL(fileURLWithPath: "/foo")
        let sample = """
        <https://api.sendgrid.com/v3/suppression/bounces?limit=a&offset=b>; rel="next"; title="2", foo, bar, baz
        """
        let headers: [String:String] = [
            "Link": sample
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: headers)
        let pages = Pagination.from(response: response)
        XCTAssertNil(pages?.first)
        XCTAssertNil(pages?.previous)
        XCTAssertNil(pages?.next)
        XCTAssertNil(pages?.last)
    }
    
}
