//
//  RetrieveSubusersTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/23/17.
//

import XCTest
import SendGrid

class RetrieveSubusersTests: XCTestCase {
    
    func testInitialization() {
        let min = RetrieveSubusers()
        XCTAssertEqual(min.description, "")
        
        let max = RetrieveSubusers(page: Page(limit: 1, offset: 2), username: "foo")
        XCTAssertEqual(max.description, "")
    }
    
    func testValidation() {        
        let goodMin = RetrieveSubusers()
        XCTAssertNoThrow(try goodMin.validate())
        
        let goodMax = RetrieveSubusers(page: Page(limit: 500, offset: 0), username: "foo")
        XCTAssertNoThrow(try goodMax.validate())
        
        do {
            let under = RetrieveSubusers(page: Page(limit: 0, offset: 0))
            try under.validate()
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, _) {
            XCTAssertEqual(i, 0)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let over = RetrieveSubusers(page: Page(limit: 501, offset: 0))
            try over.validate()
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, _) {
            XCTAssertEqual(i, 501)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
