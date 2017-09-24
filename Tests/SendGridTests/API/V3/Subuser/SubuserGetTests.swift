//
//  SubuserGetTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/23/17.
//

import XCTest
import SendGrid

class SubuserGetTests: XCTestCase {
    
    func testInitialization() {
        let min = Subuser.Get()
        XCTAssertEqual(min.endpoint?.string, "https://api.sendgrid.com/v3/subusers")
        
        let max = Subuser.Get(page: Page(limit: 1, offset: 2), username: "foo")
        XCTAssertEqual(max.endpoint?.string, "https://api.sendgrid.com/v3/subusers?limit=1&offset=2&username=foo")
    }
    
    func testValidation() {        
        let goodMin = Subuser.Get()
        XCTAssertNoThrow(try goodMin.validate())
        
        let goodMax = Subuser.Get(page: Page(limit: 500, offset: 0), username: "foo")
        XCTAssertNoThrow(try goodMax.validate())
        
        do {
            let under = Subuser.Get(page: Page(limit: 0, offset: 0))
            try under.validate()
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, _) {
            XCTAssertEqual(i, 0)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let over = Subuser.Get(page: Page(limit: 501, offset: 0))
            try over.validate()
        } catch SendGrid.Exception.Global.limitOutOfRange(let i, _) {
            XCTAssertEqual(i, 501)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
