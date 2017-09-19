//
//  BounceGetTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class BounceGetTests: XCTestCase {
    
    func testGetAllInitialization() {
        do {
            let minRequest = try Bounce.Get()
            XCTAssertEqual(minRequest.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces?limit=500&offset=0")
            
            let start = Date(timeIntervalSince1970: 15)
            let end = Date(timeIntervalSince1970: 16)
            let maxRequest = try Bounce.Get(start: start, end: end, page: Page(limit: 4, offset: 8))
            XCTAssertEqual(maxRequest.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces?limit=4&offset=8&start_time=15&end_time=16")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let _ = try Bounce.Get(page: Page(limit: 0, offset: 0))
            XCTFail("Expected an error to be thrown when the limit is below 1, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 0)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let _ = try Bounce.Get(page: Page(limit: 501, offset: 0))
            XCTFail("Expected an error to be thrown when the limit is above 500, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 501)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testEmailSpecificInitializer() {
        let request = Bounce.Get(email: "foo@example.none")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces/foo@example.none")
    }
    
}
