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
        let minRequest = Bounce.Get()
        XCTAssertEqual(minRequest.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces")
        
        let start = Date(timeIntervalSince1970: 15)
        let end = Date(timeIntervalSince1970: 16)
        let maxRequest = Bounce.Get(start: start, end: end, page: Page(limit: 4, offset: 8))
        XCTAssertEqual(maxRequest.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces?limit=4&offset=8&start_time=15&end_time=16")
    }
    
    func testEmailSpecificInitializer() {
        let request = Bounce.Get(email: "foo@example.none")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces/foo@example.none")
    }
    
    func testValidation() {
        let good = Bounce.Get(page: Page(limit: 1, offset: 1))
        XCTAssertNoThrow(try good.validate())
        
        do {
            let request = Bounce.Get(page: Page(limit: 0, offset: 0))
            try request.validate()
            XCTFail("Expected an error to be thrown when the limit is below 1, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 0)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let request = Bounce.Get(page: Page(limit: 501, offset: 0))
            try request.validate()
            XCTFail("Expected an error to be thrown when the limit is above 500, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 501)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
