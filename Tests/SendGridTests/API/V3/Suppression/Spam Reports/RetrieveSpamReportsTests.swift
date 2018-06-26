//
//  RetrieveSpamReportsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class RetrieveSpamReportsTests: XCTestCase {
    
    func testGetAllInitialization() {
        let minRequest = RetrieveSpamReports()
        XCTAssertEqual(minRequest.description, """
        # GET /v3/suppression/spam_reports

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

        """)
        
        let start = Date(timeIntervalSince1970: 15)
        let end = Date(timeIntervalSince1970: 16)
        let maxRequest = RetrieveSpamReports(start: start, end: end, page: Page(limit: 4, offset: 8))
        XCTAssertEqual(maxRequest.description, """
        # GET /v3/suppression/spam_reports?end_time=16&limit=4&offset=8&start_time=15

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

        """)
    }
    
    func testEmailSpecificInitializer() {
        let request = RetrieveSpamReports(email: "foo@example.none")
        XCTAssertEqual(request.description, """
        # GET /v3/suppression/spam_reports/foo@example.none

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

        """)
    }
    
    func testValidation() {
        do {
            let request = RetrieveSpamReports(page: Page(limit: 0, offset: 0))
            try request.validate()
            XCTFail("Expected an error to be thrown when the limit is below 1, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 0)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let request = RetrieveSpamReports(page: Page(limit: 501, offset: 0))
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
