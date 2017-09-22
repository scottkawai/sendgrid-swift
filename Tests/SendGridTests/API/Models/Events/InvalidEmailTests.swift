//
//  InvalidEmailTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/21/17.
//

import XCTest
import SendGrid

class InvalidEmailTests: XCTestCase {
    
    func testInitialization() {
        let now = Date()
        let event = InvalidEmail(email: "foo@bar", created: now, reason: "Missing TLD")
        XCTAssertEqual(event.email, "foo@bar")
        XCTAssertEqual(event.created, now)
        XCTAssertEqual(event.reason, "Missing TLD")
    }
    
}
