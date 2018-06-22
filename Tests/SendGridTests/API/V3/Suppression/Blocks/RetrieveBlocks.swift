//
//  RetrieveBlocksTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class RetrieveBlocksTests: XCTestCase {
    
    func testGetAllInitialization() {
        let minRequest = RetrieveBlocks()
        XCTAssertEqual(minRequest.description, "")
        
        let start = Date(timeIntervalSince1970: 15)
        let end = Date(timeIntervalSince1970: 16)
        let maxRequest = RetrieveBlocks(start: start, end: end, page: Page(limit: 4, offset: 8))
        XCTAssertEqual(maxRequest.description, "")
    }
    
    func testEmailSpecificInitializer() {
        let request = RetrieveBlocks(email: "foo@example.none")
        XCTAssertEqual(request.description, "")
    }
    
    func testValidation() {
        do {
            let request = RetrieveBlocks(page: Page(limit: 501, offset: 0))
            try request.validate()
            XCTFail("Expected an error to be thrown when the limit is above 500, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 501)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let request = RetrieveBlocks(page: Page(limit: 0, offset: 0))
            try request.validate()
            XCTFail("Expected an error to be thrown when the limit is below 1, but no error was thrown.")
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, let range) {
            XCTAssertEqual(i, 0)
            XCTAssertEqual(range, 1...500)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
